import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/features/auth/domain/auth_usecases.dart';

// Define authentication states
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCases authUseCases;

  AuthCubit(this.authUseCases) : super(AuthInitial());

  // Login method
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final success = await authUseCases.login(email, password);
      if (success.accessToken != '') {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Logout method
  // void logout() {
  //   authUseCases.logout();
  //   emit(AuthInitial());
  // }
}
