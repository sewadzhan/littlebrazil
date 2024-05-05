import 'dart:convert';

import 'package:equatable/equatable.dart';

class FAQModel extends Equatable {
  final String question;
  final String answer;
  final int order;

  const FAQModel(
      {required this.question, required this.answer, required this.order});

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
        question: map['question'] ?? '',
        answer: map['answer'] ?? '',
        order: map['order'] ?? 9999);
  }

  factory FAQModel.fromJson(String source) =>
      FAQModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [question, answer, order];
}
