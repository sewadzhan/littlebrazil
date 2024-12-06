import {Request, Response} from "express";
import {sendVerificationCodeToSMSC, verifyCodeAndCreateUser} from "../services/smscService";
import {handleErrorResponse} from "../config";

// Send Verification OTP
export const sendVerificationCode = async (req: Request, res: Response): Promise<void> => {
  try {
    const phone = req.body.phone as string;

    const response = await sendVerificationCodeToSMSC(phone);
    res.status(200).json(response);
  } catch (error) {
    handleErrorResponse(res, "Error sending verfication code", error);
  }
};

// Verify OTP
export const verifyOTPCode = async (req: Request, res: Response): Promise<void> => {
  try {
    const otp = req.body.otp as string;
    const uid = req.body.uid as string;
    const phone = req.body.phone as string;

    const response = await verifyCodeAndCreateUser(phone, uid, otp);
    res.status(200).json(response); // No `return` of the `res` object
  } catch (error) {
    handleErrorResponse(res, "Error verifying OTP code", error);
  }
};
