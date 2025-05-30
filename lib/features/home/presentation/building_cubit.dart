import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Define Buildingentication states
abstract class BuildingState {}

class BuildingInitial extends BuildingState {}

class BuildingLoading extends BuildingState {}

class Buildings extends BuildingState {
  final Map<String, dynamic> buildings;
  Buildings(this.buildings);
}

class BuildingAttributes extends BuildingState {
  final List<FieldSchema> attributes;
  BuildingAttributes(this.attributes);
}

class BuildingError extends BuildingState {
  final String message;
  BuildingError(this.message);
}

class BuildingAddResponse extends BuildingState {
  final bool isAdded;
  BuildingAddResponse(this.isAdded);
}

class BuildingUpdateResponse extends BuildingState {
  final bool isAdded;
  BuildingUpdateResponse(this.isAdded);
}

class BuildingCubit extends Cubit<BuildingState> {
  final BuildingUseCases buildingUseCases;

  BuildingCubit(this.buildingUseCases) : super(BuildingInitial());

  // Login method
  Future<void> getBuildings(
      LatLngBounds? bounds, double zoom, int municipalityId) async {
    emit(BuildingLoading());
    try {
      emit(Buildings(
          await buildingUseCases.getBuildings(bounds, zoom, municipalityId)));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  Future<void> getBuildingAttibutes() async {
    emit(BuildingLoading());
    try {
      emit(BuildingAttributes(await buildingUseCases.getBuildingAttibutes()));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  Future<void> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    emit(BuildingLoading());
    try {
      emit(BuildingAddResponse(
          await buildingUseCases.addBuildingFeature(attributes, points)));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  Future<void> updateBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    emit(BuildingLoading());
    try {
      emit(BuildingUpdateResponse(
          await buildingUseCases.updateBuildingFeature(attributes, points)));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }
}
