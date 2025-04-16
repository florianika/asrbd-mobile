import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define Entranceentication states
abstract class EntranceState {}

class EntranceInitial extends EntranceState {}

class EntranceLoading extends EntranceState {}

class Entrances extends EntranceState {
  final Map<String, dynamic> entrances;
  Entrances(this.entrances);
}

class EntranceError extends EntranceState {
  final String message;
  EntranceError(this.message);
}

class EntranceCubit extends Cubit<EntranceState> {
  final EntranceUseCases entranceUseCases;

  EntranceCubit(this.entranceUseCases) : super(EntranceInitial());

  // Login method
  Future<void> getEntrances() async {
    emit(EntranceLoading());
    try {
      emit(Entrances(await entranceUseCases.getEntrances()));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }
}
