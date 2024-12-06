import * as dotenv from "dotenv";
import {Response} from "express";

dotenv.config();

export const SMSCENTER_LOGIN = process.env.SMSCENTER_LOGIN || "";
export const SMSCENTER_PSW = process.env.SMSCENTER_PSW || "";

// Get formatted current date
export const getFormattedDate = (): string => {
  const now = new Date();

  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");

  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");
  const seconds = String(now.getSeconds()).padStart(2, "0");
  const milliseconds = String(now.getMilliseconds()).padStart(3, "0");

  // Get timezone offset in minutes and convert it to hours and minutes
  const timezoneOffset = -now.getTimezoneOffset(); // negative sign to align with ISO format
  const timezoneHours = String(Math.floor(Math.abs(timezoneOffset) / 60)).padStart(2, "0");
  const timezoneMinutes = String(Math.abs(timezoneOffset) % 60).padStart(2, "0");
  const timezoneSign = timezoneOffset >= 0 ? "+" : "-";

  return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}.${milliseconds}${timezoneSign}${timezoneHours}:${timezoneMinutes}`;
};


// Helper function to handle responses
export const handleErrorResponse = (res: Response, message: string, error: any) => {
  console.error(message, error);

  let statusCode = 500; // Default to Internal Server Error
  let errorMessage = message;

  // Check for specific error codes
  if (error) {
    // Firebase function-specific errors
    statusCode = mapHttpsErrorCodeToStatus(error.code);
    errorMessage = error.message;
  } else if (error.response) {
    // Errors from external API (e.g., Axios errors)
    statusCode = error.response.status || 500;
    errorMessage = error.response.data?.error || error.response.data || error.message;
  } else if (error.request) {
    // Request was made but no response was received
    statusCode = 502; // Bad Gateway
    errorMessage = "No response received from external service.";
  } else {
    // Unknown errors
    errorMessage = error.message || "An unexpected error occurred.";
  }

  return res.status(statusCode).json({
    message: errorMessage,
    details: error.stack || null,
  });
};

// Helper function to map Firebase HttpsError codes to HTTP status codes
const mapHttpsErrorCodeToStatus = (code: string): number => {
  switch (code) {
  case "cancelled":
    return 499; // Client Closed Request
  case "invalid-argument":
    return 400; // Bad Request
  case "deadline-exceeded":
    return 504; // Gateway Timeout
  case "not-found":
    return 404; // Not Found
  case "already-exists":
    return 409; // Conflict
  case "permission-denied":
    return 403; // Forbidden
  case "resource-exhausted":
    return 429; // Too Many Requests
  case "failed-precondition":
    return 412; // Precondition Failed
  case "aborted":
    return 409; // Conflict
  case "out-of-range":
    return 400; // Bad Request
  case "unimplemented":
    return 501; // Not Implemented
  case "internal":
    return 500; // Internal Server Error
  case "unavailable":
    return 503; // Service Unavailable
  case "data-loss":
    return 500; // Internal Server Error
  case "unauthenticated":
    return 401; // Unauthorized
  default:
    return 500; // Internal Server Error
  }
};


