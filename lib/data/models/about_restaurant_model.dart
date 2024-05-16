import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/employee.dart';

class AboutRestaurantModel extends Equatable {
  final List<String> images;
  final List<Employee> employees;
  final Map<String, String> ourHistory;
  final int numOfExperience;
  final int numOfChiefs;
  final int numOfEmployees;

  const AboutRestaurantModel(
      {required this.images,
      required this.employees,
      required this.ourHistory,
      required this.numOfExperience,
      required this.numOfChiefs,
      required this.numOfEmployees});

  @override
  List<Object?> get props =>
      [images, employees, ourHistory, numOfChiefs, numOfEmployees, numOfChiefs];

  factory AboutRestaurantModel.fromMap(Map<String, dynamic> map) {
    List<Employee> employees = List<Map<String, dynamic>>.from(map['employees'])
        .map((e) => Employee(
            name: e["name"].cast<String, String>(),
            position: e["position"].cast<String, String>(),
            imageUrl: e['imageUrl']))
        .toList();

    return AboutRestaurantModel(
        images: List.from(map['images']),
        employees: employees,
        ourHistory: map["ourHistory"].cast<String, String>(),
        numOfExperience: map['experienceYears'] ?? 0,
        numOfChiefs: map['numOfChiefs'] ?? 0,
        numOfEmployees: map['numOfEmployees'] ?? 0);
  }

  factory AboutRestaurantModel.fromJson(String source) =>
      AboutRestaurantModel.fromMap(json.decode(source));

  AboutRestaurantModel copyWith({
    List<String>? images,
    List<Employee>? employees,
    Map<String, String>? ourHistory,
    int? numOfExperience,
    int? numOfChiefs,
    int? numOfEmployees,
  }) {
    return AboutRestaurantModel(
      images: images ?? this.images,
      employees: employees ?? this.employees,
      ourHistory: ourHistory ?? this.ourHistory,
      numOfExperience: numOfExperience ?? this.numOfExperience,
      numOfChiefs: numOfChiefs ?? this.numOfChiefs,
      numOfEmployees: numOfEmployees ?? this.numOfEmployees,
    );
  }
}
