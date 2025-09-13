import 'package:asrdb/core/services/street_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/main.dart';
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
      final user = await sl<UserService>().initialize();
      if (user != null) {
        await sl<StreetService>().clearAllStreets();
        final streets = await sl<StreetService>().getStreets(user.municipality);
        sl<StreetService>().saveStreets(streets);
      }
      if (success.accessToken != '' && user != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Logout method
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authUseCases.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
