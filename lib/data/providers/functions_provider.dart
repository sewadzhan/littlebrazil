import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:littlebrazil/view/config/restaurant_exception.dart';

class FunctionsProvider {
  // final String baseUrl =
  //     'http://10.0.2.2:5001/little-brazil/asia-south2/api'; // Android
  // final String baseUrl =
  //     'http://localhost:5001/little-brazil/asia-south2/api'; // iOS

  final String baseUrl = 'https://api-c7dp7imnja-em.a.run.app/';

  const FunctionsProvider();

  // Sending verification code to phone number
  Future<Map<String, dynamic>> sendVerificationCode({
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendCode'),
      body: {
        'phone': phone,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw RestaurantException('Failed to send verification code');
    }
  }

  // Verifying OTP code
  Future<Map<String, dynamic>> verifyOTP({
    required String otp,
    required String uid,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verifyCode'),
      body: {
        "phone": phone,
        "otp": otp,
        "uid": uid,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw RestaurantException('Failed to verify OTP');
    }
  }

  // Fetching the menu
  Future<Map<String, dynamic>> getMenu() async {
    final response = await http.get(
      Uri.parse('$baseUrl/menu'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw RestaurantException('Failed to fetch menu');
    }
  }

  // Creating a new order
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> orderData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/order/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw RestaurantException('Failed to create order');
    }
  }

  // Getting order details by ID
  Future<Map<String, dynamic>> getOrderDetails({
    required String orderId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/order/internal/$orderId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw RestaurantException('Failed to fetch order details');
    }
  }

  // Closing an internal order
  Future<Map<String, dynamic>> closeInternalOrder({
    required Map<String, dynamic> closeOrderData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/order/internal/close'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(closeOrderData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw RestaurantException('Failed to close internal order');
    }
  }
}
