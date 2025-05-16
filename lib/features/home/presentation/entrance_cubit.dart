import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

class EntranceAddResponse extends EntranceState {
  final bool isAdded;
  EntranceAddResponse(this.isAdded);
}

class EntranceUpdateResponse extends EntranceState {
  final bool isAdded;
  EntranceUpdateResponse(this.isAdded);
}

class EntranceDeleteResponse extends EntranceState {
  final bool isAdded;
  EntranceDeleteResponse(this.isAdded);
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

  Future<void> addEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    emit(EntranceLoading());
    try {
      emit(EntranceAddResponse(
          await entranceUseCases.addEntranceFeature(attributes, points)));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> updateEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    emit(EntranceLoading());
    try {
      emit(EntranceUpdateResponse(
          await entranceUseCases.updateEntranceFeature(attributes, points)));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }

  Future<void> deleteEntranceFeature(String objectId) async {
    emit(EntranceLoading());
    try {
      emit(EntranceDeleteResponse(
          await entranceUseCases.deleteEntranceFeature(objectId)));
    } catch (e) {
      emit(EntranceError(e.toString()));
    }
  }
}
