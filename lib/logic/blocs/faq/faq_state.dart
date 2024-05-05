part of 'faq_bloc.dart';

abstract class FAQState extends Equatable {
  const FAQState();

  @override
  List<Object> get props => [];
}

class FAQInitial extends FAQState {}

class FAQLoading extends FAQState {}

class FAQLoaded extends FAQState {
  final List<FAQModel> faqModels;

  const FAQLoaded(this.faqModels);

  @override
  List<Object> get props => [faqModels];
}

class FAQErrorState extends FAQState {
  final String message;

  const FAQErrorState(this.message);

  @override
  List<Object> get props => [message];
}
