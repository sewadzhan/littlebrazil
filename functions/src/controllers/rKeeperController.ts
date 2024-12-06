// controllers/rkeeperController.ts
import {Request, Response} from "express";
import axios from "axios";

const RKEEPER_API_URL = "";
const API_KEY = "";

// Fetch the current menu from rKeeper
export const getMenu = async (req: Request, res: Response) => {
  try {
    const response = await axios.get(`${RKEEPER_API_URL}/menu`, {
      headers: {Authorization: `Bearer ${API_KEY}`},
    });
    res.status(200).json(response.data);
  } catch (error) {
    console.error("Error fetching menu:", error);
    res.status(500).json({message: "Failed to fetch menu"});
  }
};

// Create a new order in rKeeper
export const createOrder = async (req: Request, res: Response) => {
  try {
    const orderData = req.body; // Expecting order details in the request body
    const response = await axios.post(`${RKEEPER_API_URL}/order/create`, orderData, {
      headers: {Authorization: `Bearer ${API_KEY}`},
    });
    res.status(201).json(response.data);
  } catch (error) {
    console.error("Error creating order:", error);
    res.status(500).json({message: "Failed to create order"});
  }
};

// Get details of an internal order by ID
export const getOrderDetails = async (req: Request, res: Response) => {
  try {
    const {orderId} = req.params;
    const response = await axios.get(`${RKEEPER_API_URL}/order/internal/${orderId}`, {
      headers: {Authorization: `Bearer ${API_KEY}`},
    });
    res.status(200).json(response.data);
  } catch (error) {
    console.error("Error fetching order details:", error);
    res.status(500).json({message: "Failed to fetch order details"});
  }
};

// Close an internal order in rKeeper
export const closeInternalOrder = async (req: Request, res: Response) => {
  try {
    const closeOrderData = req.body; // Expecting details for closing the order in the request body
    const response = await axios.post(`${RKEEPER_API_URL}/order/internal/close`, closeOrderData, {
      headers: {Authorization: `Bearer ${API_KEY}`},
    });
    res.status(200).json(response.data);
  } catch (error) {
    console.error("Error closing internal order:", error);
    res.status(500).json({message: "Failed to close internal order"});
  }
};
