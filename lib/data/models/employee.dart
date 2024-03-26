import 'package:equatable/equatable.dart';

//Model for About Restaurant Screen
class Employee extends Equatable {
  final String name;
  final String position;
  final String imageUrl;

  const Employee(
      {required this.name, required this.position, required this.imageUrl});

  @override
  List<Object?> get props => [name, position, imageUrl];
}
