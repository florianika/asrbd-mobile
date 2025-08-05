import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
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
  final String globalId;
  BuildingAddResponse(this.globalId);
}

class BuildingUpdateResponse extends BuildingState {
  final String globalId;
  BuildingUpdateResponse(this.globalId);
}

class BuildingCount extends BuildingState {
  final int count;
  BuildingCount(this.count);
}

// Cubit
class BuildingCubit extends Cubit<BuildingState> {
  final BuildingUseCases buildingUseCases;
  final AttributesCubit attributesCubit;
  final DwellingCubit dwellingCubit;
  final OutputLogsCubit outputLogsCubit;
  String? _selectedBuildingGlobalId;

  BuildingCubit(
    this.buildingUseCases,
    this.attributesCubit,
    this.dwellingCubit,
    this.outputLogsCubit,
  ) : super(BuildingInitial());

  /// Get buildings by bounds
  Future<void> getBuildings(
      LatLngBounds? bounds, double zoom, int municipalityId) async {
    emit(BuildingLoading());
    try {
      final buildings =
          await buildingUseCases.getBuildings(bounds, zoom, municipalityId);
      emit(Buildings(buildings));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Select and load building details
  Future<void> getBuildingDetails(String globalId) async {
    emit(BuildingLoading());
    try {
      _selectedBuildingGlobalId =
          globalId.replaceAll('{', '').replaceAll('}', '');

      attributesCubit.showAttributes(true);
      await attributesCubit.showBuildingAttributes(_selectedBuildingGlobalId);

      emit(BuildingGlobalId(_selectedBuildingGlobalId));
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
      final globalId =
          await buildingUseCases.addBuildingFeature(attributes, points);
      emit(BuildingAddResponse(globalId));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Update existing building
  Future<void> updateBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng>? points) async {
    emit(BuildingLoading());
    try {
      await buildingUseCases.updateBuildingFeature(attributes, points);
      emit(BuildingUpdateResponse(attributes[GeneralFields.globalID]));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  Future<void> startReviewing(String globalId, int value) async {
    emit(BuildingLoading());
    try {
      await buildingUseCases.startReviewing(globalId, value);
      emit(BuildingUpdateResponse(globalId));
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

  // Future<void> getBuildingsCount(LatLngBounds bounds, int municipalityId) async {
  //   emit(BuildingLoading());
  //   try {
  //     final count =
  //         await buildingUseCases.getBuildingsCount(bounds, municipalityId);
  //     emit(BuildingCount(count));
  //   } catch (e) {
  //     emit(BuildingError(e.toString()));
  //   }
  // }

  void clearBuildings() {
    _selectedBuildingGlobalId = null;
    emit(Buildings({}));
  }
}
