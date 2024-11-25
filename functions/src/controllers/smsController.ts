import { Request, Response } from "express";
import { sendVerificationCodeToTwilio, verifyCodeAndCreateUser } from "../services/twilioService";

// Send Verification OTP
export const sendVerificationCode = async (req: Request, res: Response) => {
  try {
    const phone = req.body.phone as string;

    const response = await sendVerificationCodeToTwilio(phone);
    return res.status(200).json(response);
  } catch (error) {
    return handleErrorResponse(res, "Error sending verfication code", error);
  }
};

// Verify OTP
export const verifyOTPCode = async (req: Request, res: Response) => {
  try {
    const otp = req.body.otp as string;
    const uid = req.body.uid as string;
    const phone = req.body.phone as string;

    const response = await verifyCodeAndCreateUser(phone, uid, otp);
    return res.status(200).json(response);
  } catch (error) {
    return handleErrorResponse(res, "Error sending verfication code", error);
  }
};