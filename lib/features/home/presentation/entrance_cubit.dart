import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

// Define Entranceentication states
abstract class EntranceState {}

class EntranceInitial extends EntranceState {}

class EntranceLoading extends EntranceState {}

class Entrances extends EntranceState {
  final Map<String, dynamic> entrances;
  Entrances(this.entrances);
}

class EntranceAttributes extends EntranceState {
  final List<FieldSchema> attributes;
  EntranceAttributes(this.attributes);
}

class EntranceError extends EntranceState {
  final String message;
  EntranceError(this.message);
}

class EntranceCubit extends Cubit<EntranceState> {
  final EntranceUseCases entranceUseCases;

  EntranceCubit(this.entranceUseCases) : super(EntranceInitial());

  // Login method
  Future<void> getEntrances(LatLngBounds? bounds, double zoom) async {
    emit(EntranceLoading());
    try {
      emit(Entrances(await entranceUseCases.getEntrances(bounds, zoom)));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> getEntranceAttributes() async {
    emit(EntranceLoading());
    try {
      emit(EntranceAttributes(await entranceUseCases.getEntranceAttributes()));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }
}
