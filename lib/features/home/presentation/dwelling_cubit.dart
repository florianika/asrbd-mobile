import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class DwellingState {}

class DwellingInitial extends DwellingState {}

class DwellingLoading extends DwellingState {}

class Dwellings extends DwellingState {
  final Map<String, dynamic> buildings;
  Dwellings(this.buildings);
}

class DwellingAttributes extends DwellingState {
  final List<FieldSchema> attributes;
  DwellingAttributes(this.attributes);
}

class DwellingError extends DwellingState {
  final String message;
  DwellingError(this.message);
}

class DwellingCubit extends Cubit<DwellingState> {
  final DwellingUseCases buildingUseCases;

  DwellingCubit(this.buildingUseCases) : super(DwellingInitial());

  // Login method
  Future<void> getDwellings(LatLngBounds? bounds, double zoom) async {
    emit(DwellingLoading());
    try {
      emit(Dwellings(await buildingUseCases.getDwellings(bounds, zoom)));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }

  Future<void> getDwellingAttibutes() async {
    emit(DwellingLoading());
    try {
      emit(DwellingAttributes(await buildingUseCases.getDwellingAttibutes()));
    } catch (e) {
      emit(DwellingError(e.toString()));
    }
  }
}
