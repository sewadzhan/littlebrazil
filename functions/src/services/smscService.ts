import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {Timestamp} from "firebase-admin/firestore";
import {error} from "console";
// import axios from "axios";
// import { SMSCENTER_LOGIN, SMSCENTER_PSW } from "../config";

admin.initializeApp();
const db = admin.firestore();

/**
 * Sends a verification code to the given phone number via SMS.
 *
 * @param {string} phone - The phone number to send the verification code to.
 * @return {Promise<{uid: string}>} - The UID of the created verification document.
 * @throws {functions.https.HttpsError} - Throws an error if the SMS sending fails or other issues occur.
 */
export const sendVerificationCodeToSMSC = async (phone: string): Promise<{ uid: string }> => {
  // const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
  const verificationCode = "123456";

  const verificationDoc = await db.collection("phoneVerification").add({
    code: verificationCode,
    phone,
    createdAt: Timestamp.now(),
  });

  const uid = verificationDoc.id;

  try {
    // Simulate SMS sending logic (commented out)
    // const response = await axios.get(`https://smsc.kz/sys/send.php?...`);

  } catch (error) {
    console.error("Error sending SMS via SMSC:", error);
    throw new functions.https.HttpsError("internal", "Failed to send SMS.");
  }

  return {uid};
};

/**
 * Verifies the provided OTP code and creates a user if it doesn't exist.
 *
 * @param {string} phone - The phone number associated with the verification code.
 * @param {string} uid - The UID of the verification document in Firestore.
 * @param {string} otp - The OTP code provided by the user.
 * @return {Promise<{customToken: string}>} - A custom authentication token for the user.
 * @throws {functions.https.HttpsError} - Throws an error if verification fails or user creation encounters issues.
 */
export const verifyCodeAndCreateUser = async (
  phone: string,
  uid: string,
  otp: string
): Promise<{ customToken: string }> => {
  const verificationDocRef = db.collection("phoneVerification").doc(uid);
  const verificationDoc = await verificationDocRef.get();

  if (!verificationDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Verification document not found.");
  }

  const {code: storedCode, createdAt} = verificationDoc.data() || {};

  if (storedCode.trim() !== otp.trim()) {
    throw new functions.https.HttpsError("invalid-argument", "Incorrect verification code.");
  }

  if (createdAt) {
    // Add expiration logic here if needed
  } else {
    throw new functions.https.HttpsError("internal", "Timestamp not found.");
  }

  let customToken = "";

  try {
    const userRecord = await admin.auth().getUserByPhoneNumber(phone);
    customToken = await admin.auth().createCustomToken(userRecord.uid);
  } catch (e: any) {
    if (JSON.stringify(e).includes("user-not-found")) {
      try {
        const newUserRecord = await admin.auth().createUser({
          phoneNumber: phone,
        });
        customToken = await admin.auth().createCustomToken(newUserRecord.uid);
      } catch (createUserError: any) {
        error(createUserError);
        // console.error("Error creating new user:", createUserError.message);
        throw new functions.https.HttpsError("internal", "Error creating a new user.");
      }
    } else {
      console.error("Unexpected error:", e.message);
      throw new functions.https.HttpsError("internal", "Unexpected error occurred while fetching user.");
    }
  }

  await db.collection("phoneVerification").doc(uid).delete();

  return {customToken};
};
