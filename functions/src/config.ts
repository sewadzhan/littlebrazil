import * as dotenv from "dotenv";
import { Response } from "express";

dotenv.config();

export const ALTEGIO_API_URL = process.env.ALTEGIO_API_URL || "https://api.alteg.io/api/v1";
export const ALTEGIO_PARTNER_TOKEN = process.env.ALTEGIO_PARTNER_TOKEN || "";
export const ALTEGIO_USER_TOKEN = process.env.ALTEGIO_USER_TOKEN || "";
export const ALTEGIO_COMPANY_ID = process.env.ALTEGIO_COMPANY_ID || "";
export const ALTEGIO_CHAIN_ID = process.env.ALTEGIO_CHAIN_ID || "";
export const TWILIO_ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID || "";
export const TWILIO_AUTH_TOKEN = process.env.TWILIO_AUTH_TOKEN || "";
export const TWILIO_TEMPLATE_SID = process.env.TWILIO_TEMPLATE_SID || "";

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
  return res.status(500).json({ message, error: error.message || error });
};
