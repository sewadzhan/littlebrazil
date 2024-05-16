import 'package:equatable/equatable.dart';

//Model for About Restaurant Screen
class Employee extends Equatable {
  final Map<String, String> name;
  final Map<String, String> position;
  final String imageUrl;

  const Employee(
      {required this.name, required this.position, required this.imageUrl});

  @override
  List<Object?> get props => [name, position, imageUrl];
}
