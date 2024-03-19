import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<User?> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(null) {
    getCurrentUser();
  }

  void getCurrentUser() async {
    emit(await authRepository.getCurrentUser());
  }

  void signOut() {
    authRepository.signOut();
    emit(null);
  }

  void deleteUser() {
    authRepository.deleteCurrentUser();
    emit(null);
  }
}
