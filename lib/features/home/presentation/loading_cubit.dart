import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingState {
  final bool isLoading;

  const LoadingState({this.isLoading = false});
}

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(const LoadingState());

  void show() => emit(const LoadingState(isLoading: true));
  void hide() => emit(const LoadingState(isLoading: false));
}
