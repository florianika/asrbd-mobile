import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/features/auth/domain/auth_usecases.dart';

// Define forgot password states
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthUseCases authUseCases;

  ForgotPasswordCubit(this.authUseCases) : super(ForgotPasswordInitial());

  // Forgot password method
  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());
    try {
      await authUseCases.forgotPassword(email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
