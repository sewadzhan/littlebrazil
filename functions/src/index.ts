// index.ts
import * as functions from "firebase-functions/v2";
import * as express from "express";
import {sendVerificationCode, verifyOTPCode} from "./controllers/smsController";
import {closeInternalOrder, createOrder, getMenu, getOrderDetails} from "./controllers/rKeeperController";

functions.setGlobalOptions({region: "asia-south2"});

// Initialize the Express app
const app = express();
app.use(express.json());

// SMS Verification Routes
app.post("/sendCode", sendVerificationCode);
app.post("/verifyCode", verifyOTPCode);

// rKeeper Routes
app.get("/menu", getMenu); // Route to fetch the menu
app.post("/order/create", createOrder); // Route to create a new order
app.get("/order/internal/:orderId", getOrderDetails); // Route to get details of an internal order
app.post("/order/internal/close", closeInternalOrder); // Route to close an internal order

// Export the app as a Firebase Function
export const api = functions.https.onRequest(app);
