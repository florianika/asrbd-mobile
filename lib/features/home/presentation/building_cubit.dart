import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// States
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

class BuildingGlobalId extends BuildingState {
  final String? globalId;
  BuildingGlobalId(this.globalId);
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
  final bool isUpdated;
  BuildingUpdateResponse(this.isUpdated);
}

// Cubit
class BuildingCubit extends Cubit<BuildingState> {
  final BuildingUseCases buildingUseCases;
  final AttributesCubit attributesCubit;

  String? _selectedBuildingGlobalId;

  BuildingCubit(this.buildingUseCases, this.attributesCubit)
      : super(BuildingInitial());

  /// Get buildings by bounds
  Future<void> getBuildings(
      LatLngBounds? bounds, double zoom, int municipalityId) async {
    emit(BuildingLoading());
    try {
      final buildings = await buildingUseCases.getBuildings(bounds, zoom, municipalityId);
      emit(Buildings(buildings));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Select and load building details
  Future<void> getBuildingDetails(String globalId) async {
    emit(BuildingLoading());
    try {
      _selectedBuildingGlobalId = globalId;
      emit(BuildingGlobalId(globalId));

      // Show attribute panel
      attributesCubit.showAttributes(true);
      await attributesCubit.showBuildingAttributes(globalId);
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Load attribute schema
  Future<void> getBuildingAttributes() async {
    emit(BuildingLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      emit(BuildingAttributes(schema));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Add new building geometry
  Future<void> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    emit(BuildingLoading());
    try {
      final result = await buildingUseCases.addBuildingFeature(attributes, points);
      emit(BuildingAddResponse(result));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Update existing building
  Future<void> updateBuildingFeature(Map<String, dynamic> attributes) async {
    emit(BuildingLoading());
    try {
      final result = await buildingUseCases.updateBuildingFeature(attributes);
      emit(BuildingUpdateResponse(result));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Public getter for current globalId
  String? get globalId => _selectedBuildingGlobalId;

  /// Public method to manually set and emit globalId
  void selectBuildingByGlobalId(String? globalId) {
    _selectedBuildingGlobalId = globalId;
    emit(BuildingGlobalId(globalId));
  }
}