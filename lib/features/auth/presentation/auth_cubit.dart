import 'package:asrdb/core/services/street_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/core/field_work_status_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/features/auth/domain/auth_usecases.dart';

// Define authentication states
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthOtpVerified extends AuthState {}

class AuthOtpRequired extends AuthState {
  final String userId;
  AuthOtpRequired(this.userId);
}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated(this.userId);
}

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

      if (success.userId != '') {
        emit(AuthOtpRequired(success.userId));
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

  Future<void> verifyOtp(String userId, String pin) async {
    emit(AuthLoading());
    try {
      final success = await authUseCases.verifyOtp(userId, pin);
      final user = await sl<UserService>().initialize();
      if (user != null) {
        await sl<StreetService>().clearAllStreets();
        final streets = await sl<StreetService>().getStreets(user.municipality);
        sl<StreetService>().saveStreets(streets);
      }
      if (success.accessToken != '' && user != null) {
        // Connect WebSocket after successful login
        try {
          final fieldWorkCubit = sl<FieldWorkCubit>();
          await fieldWorkCubit.connect();
        } catch (e) {
          // Ignore if FieldWorkCubit is not registered or fails
        }
        emit(AuthAuthenticated(userId));
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resendOtp() async {
    emit(AuthLoading());
    try {
      // final success = await authUseCases.login(email, password);
      final user = await sl<UserService>().initialize();
      if (user != null) {
        await sl<StreetService>().clearAllStreets();
        final streets = await sl<StreetService>().getStreets(user.municipality);
        sl<StreetService>().saveStreets(streets);
      }
      // if (success.accessToken != '' && user != null) {
      //   emit(AuthAuthenticated());
      // } else {
      //   emit(AuthError("Invalid credentials"));
      // }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final userId = await authUseCases.getLoggedInUserId();
      if (userId != null) {
        // Also initialize user service and street service as in verifyOtp
        final user = await sl<UserService>().initialize();
        if (user != null) {
          await sl<StreetService>().clearAllStreets();
          final streets = await sl<StreetService>().getStreets(user.municipality);
          sl<StreetService>().saveStreets(streets);
          emit(AuthAuthenticated(userId));
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
