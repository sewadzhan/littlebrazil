import 'dart:convert';

import 'package:equatable/equatable.dart';

class FAQModel extends Equatable {
  final Map<String, String> question;
  final Map<String, String> answer;
  final int order;

  const FAQModel(
      {required this.question, required this.answer, required this.order});

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
        question: map["question"].cast<String, String>(),
        answer: map["answer"].cast<String, String>(),
        order: map['order'] ?? 9999);
  }

  factory FAQModel.fromJson(String source) =>
      FAQModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [question, answer, order];
}
