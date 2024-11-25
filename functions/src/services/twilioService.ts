import twilio from "twilio";
import * as admin from "firebase-admin";
import { TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_TEMPLATE_SID } from "../config";
import * as functions from "firebase-functions/v2";
import { error } from "firebase-functions/logger";
import { Timestamp } from "firebase-admin/firestore";
import * as bcrypt from "bcryptjs";

const client = twilio(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);

admin.initializeApp();
const db = admin.firestore();

const MAX_REQUESTS = 7; // Max OTP requests in the window
const RATE_LIMIT_WINDOW_MS = 60 * 60 * 1000; // 1 hour
const COOLDOWN_PERIOD_MS = 1 * 60 * 1000; // 1 minute

// Check if OTP requests are within allowed rate limits
export async function checkRateLimit(phoneNumber: string): Promise<boolean> {
    const userRef = db.collection("otp_requests").doc(phoneNumber);
    const doc = await userRef.get();

    // If the document does not exist, no requests have been made yet.
    if (!doc.exists) {
        // Initialize the document with a new request
        await userRef.set({
            lastRequestTime: Timestamp.now(),
            requestCount: 1,
        });
        return true; // Allow OTP request
    }

    const data = doc.data();
    const lastRequestTime = data?.lastRequestTime?.toDate().getTime();
    const requestCount = data?.requestCount || 0;

    // Check if the request count exceeds the limit within the time window
    if (lastRequestTime && Date.now() - lastRequestTime < RATE_LIMIT_WINDOW_MS) {
        if (requestCount >= MAX_REQUESTS) {
            return false; // Too many requests within the time window
        }
    } else {
        // Reset the counter if the time window has passed
        await userRef.update({
            lastRequestTime: Timestamp.now(),
            requestCount: 1,
        });
        return true; // Allow OTP request
    }

    // Otherwise, allow OTP request
    await userRef.update({
        lastRequestTime: Timestamp.now(),
        requestCount: admin.firestore.FieldValue.increment(1),
    });
    return true;
}

// Check if the user is within the cooldown period
export async function checkCooldown(phoneNumber: string): Promise<boolean> {
    const otpRef = db.collection("otp_requests").doc(phoneNumber);
    const doc = await otpRef.get();

    if (!doc.exists) {
        // If no previous request exists, allow the OTP request
        await otpRef.set({
            lastRequestTime: Timestamp.now(),
            requestCount: 1,
        });
        return true;
    }

    const data = doc.data();
    const lastRequestTime = data?.lastRequestTime?.toDate().getTime();

    if (lastRequestTime && Date.now() - lastRequestTime < COOLDOWN_PERIOD_MS) {
        return false; // Within the cooldown period, deny request
    }

    // Update the last request time if cooldown period has passed
    await otpRef.update({
        lastRequestTime: Timestamp.now(),
    });

    return true; // Allow OTP request
}

/**
 * Function to generate and send verification code via SMS
 */
export const sendVerificationCodeToTwilio = async (phone: string) => {
    // Check if the phone number has exceeded rate limits or is in cooldown
    // if (!(await checkRateLimit(phone)) || !(await checkCooldown(phone))) {
    //     throw new functions.https.HttpsError(
    //         "resource-exhausted",
    //         "Too many OTP requests. Please try again later."
    //     );
    // }

    // Generate a 6-digit verification code
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    const hashedCode = await bcrypt.hash(verificationCode, 10);

    error(verificationCode)

    // Create a Firestore document to store the verification code
    const verificationDoc = await db.collection("phoneVerification").add({
        code: hashedCode,
        phone,
        createdAt: Timestamp.now(),
    });

    const uid = verificationDoc.id;

    try {
        await client.messages.create({
            from: "whatsapp:+14155238886", //12317146350
            to: `whatsapp:${phone}`,
            body: "",
            persistentAction: ["template:atmos_fit_otp"],
            contentSid: TWILIO_TEMPLATE_SID,
            contentVariables: JSON.stringify({
                "1": verificationCode,
            }),
        });
    } catch (error) {
        console.error("Error sending SMS via Twilio:", error);
        throw new functions.https.HttpsError("internal", "Failed to send SMS.");
    }

    return { uid };
};

/**
 * Function to verify the code provided by the user
 */
export const verifyCodeAndCreateUser = async (phone: string, uid: string, otp: string) => {
    const verificationDocRef = db.collection("phoneVerification").doc(uid);
    const verificationDoc = await verificationDocRef.get();

    if (!verificationDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Verification document not found.");
    }

    const { code: storedCode, createdAt } = verificationDoc.data() || {};

    // Compare the provided code with the hashed code in Firestore
    const isMatch = await bcrypt.compare(storedCode, otp);
    if (!isMatch) {
        throw new functions.https.HttpsError("invalid-argument", "Incorrect verification code.");
    }

    // Check if the code is still valid (5 minutes expiration)
    if (createdAt) {
        const currentTime = admin.firestore.Timestamp.now();
        const timeDifference = currentTime.seconds - createdAt.seconds;

        if (timeDifference > 5 * 60) {
            await verificationDocRef.delete();
            throw new functions.https.HttpsError("deadline-exceeded", "Verification code has expired.");
        }
    } else {
        throw new functions.https.HttpsError("internal", "Timestamp not found.");
    }

    var customToken: string = "";

    try {
        const userRecord = await admin.auth().getUserByPhoneNumber(phone);

        customToken = await admin.auth().createCustomToken(userRecord.uid);

    } catch (error: any) {
        // If user does not exist, create a new user
        if (error.code === 'auth/user-not-found') {
            const newUserRecord = await admin.auth().createUser({
                phoneNumber: phone,
            });
            // Generate a custom auth token for the newly created user
            customToken = await admin.auth().createCustomToken(newUserRecord.uid);
        }

        // Handle any other errors
        throw new functions.https.HttpsError("internal", "Error creating or fetching user");
    }

    // If code is correct, delete the document
    await db.collection("phoneVerification").doc(uid).delete();

    return { customToken };
};