part of 'contacts_cubit.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsLoadingState extends ContactsState {}

class ContactsLoadedState extends ContactsState {
  final ContactsModel contactsModel;

  const ContactsLoadedState({required this.contactsModel});

  @override
  List<Object?> get props => [contactsModel];
}

class ContactsErrorState extends ContactsState {}
