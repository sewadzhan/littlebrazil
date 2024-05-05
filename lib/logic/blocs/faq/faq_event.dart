part of 'faq_bloc.dart';

abstract class FAQEvent extends Equatable {
  const FAQEvent();

  @override
  List<Object> get props => [];
}

class LoadFAQs extends FAQEvent {
  const LoadFAQs();
}
