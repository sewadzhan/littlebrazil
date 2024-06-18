part of 'about_company_cubit.dart';

abstract class AboutCompanyState extends Equatable {
  const AboutCompanyState();

  @override
  List<Object?> get props => [];
}

class AboutCompanyLoadingState extends AboutCompanyState {
  const AboutCompanyLoadingState();
}

class AboutCompanyLoadedState extends AboutCompanyState {
  final AboutCompanyModel aboutCompanyModel;

  const AboutCompanyLoadedState({required this.aboutCompanyModel});

  @override
  List<Object?> get props => [aboutCompanyModel];
}

class AboutCompanyErrorState extends AboutCompanyState {
  const AboutCompanyErrorState();
}
