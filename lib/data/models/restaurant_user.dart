import 'dart:convert';

import 'package:equatable/equatable.dart';

//Model of Pikapika user
class RestaurantUser extends Equatable {
  final String phoneNumber;
  final String name;
  final String email;
  final String birthday;
  final int cashback;
  final List<String> usedPromocodes;
  final bool isAdmin;

  const RestaurantUser({
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.birthday,
    this.cashback = 0,
    this.usedPromocodes = const [],
    this.isAdmin = false,
  });

  @override
  List<Object?> get props =>
      [phoneNumber, name, email, birthday, cashback, usedPromocodes, isAdmin];

  @override
  String toString() {
    return "Pikapika user: $phoneNumber name: $name  email: $email birthday: $birthday cashback: $cashback";
  }

  factory RestaurantUser.fromMap(Map<String, dynamic> map) {
    return RestaurantUser(
        phoneNumber: map["phoneNumber"] ?? "",
        name: map["name"] ?? "",
        email: map["email"] ?? "",
        birthday: map["birthday"] ?? "",
        cashback: map["cashback"] ?? 0,
        usedPromocodes: map["usedPromocodes"] ?? [],
        isAdmin: map["isAdmin"] ?? false);
  }

  factory RestaurantUser.fromJson(String source) =>
      RestaurantUser.fromMap(json.decode(source));

  RestaurantUser copyWith(
      {String? phoneNumber,
      String? name,
      String? email,
      String? birthday,
      int? cashback,
      List<String>? usedPromocodes}) {
    return RestaurantUser(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      cashback: cashback ?? this.cashback,
    );
  }
}
