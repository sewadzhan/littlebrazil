import 'dart:convert';

import 'package:equatable/equatable.dart';

class AboutCompanyModel extends Equatable {
  final String offerUrl;
  final String policyUrl;
  final String paymentTermsUrl;
  final String companyInfoUrl;
  final String deliveryTermsUrl;

  const AboutCompanyModel(
      {required this.offerUrl,
      required this.policyUrl,
      required this.paymentTermsUrl,
      required this.companyInfoUrl,
      required this.deliveryTermsUrl});

  @override
  List<Object?> get props =>
      [offerUrl, policyUrl, paymentTermsUrl, companyInfoUrl];

  factory AboutCompanyModel.fromMap(Map<String, dynamic> map) {
    return AboutCompanyModel(
      offerUrl: map["offerUrl"],
      policyUrl: map['policyUrl'],
      paymentTermsUrl: map['paymentTermsUrl'],
      companyInfoUrl: map['companyInfoUrl'],
      deliveryTermsUrl: map['deliveryTermsUrl'],
    );
  }

  factory AboutCompanyModel.fromJson(String source) =>
      AboutCompanyModel.fromMap(json.decode(source));

  AboutCompanyModel copyWith({
    String? offerUrl,
    String? policyUrl,
    String? paymentTermsUrl,
    String? companyInfoUrl,
    String? deliveryTermsUrl,
  }) {
    return AboutCompanyModel(
        offerUrl: offerUrl ?? this.offerUrl,
        policyUrl: policyUrl ?? this.policyUrl,
        paymentTermsUrl: paymentTermsUrl ?? this.paymentTermsUrl,
        companyInfoUrl: companyInfoUrl ?? this.companyInfoUrl,
        deliveryTermsUrl: deliveryTermsUrl ?? this.deliveryTermsUrl);
  }
}
