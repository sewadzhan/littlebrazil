import * as admin from "firebase-admin";
import {Timestamp} from "firebase-admin/firestore";

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
