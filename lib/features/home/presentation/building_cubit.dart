import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

// States
abstract class BuildingState {}

class BuildingInitial extends BuildingState {}

class BuildingLoading extends BuildingState {}

class Buildings extends BuildingState {
  final List<BuildingEntity> buildings;
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
  List<BuildingEntity> _buildings = []; // ✅ Store buildings privately

  BuildingCubit(
    this.buildingUseCases,
    this.attributesCubit,
    this.dwellingCubit,
    this.outputLogsCubit,
  ) : super(BuildingInitial());

  /// Get buildings by bounds
  Future<void> getBuildings(LatLngBounds? bounds, double zoom,
      int municipalityId, bool isOffline, int? downloadId) async {
    emit(BuildingLoading());
    try {
      final buildings = await buildingUseCases.getBuildings(
        bounds,
        zoom,
        municipalityId,
        isOffline,
        downloadId
      );
      _buildings = buildings;
      emit(Buildings(buildings));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Update building coordinates
  Future<void> updateBuildingCoordinates(BuildingEntity building) async {
    // Use stored buildings regardless of current state
    if (_buildings.isEmpty) return;

    emit(BuildingLoading());

    try {
      final buildings = List<BuildingEntity>.from(_buildings);
      final buildingIndex =
          buildings.indexWhere((b) => b.globalId == building.globalId);

      if (buildingIndex != -1) {
        buildings[buildingIndex] = building; // Replace with updated building
        _buildings = buildings; // ✅ Update stored buildings
        emit(Buildings(buildings));
      } else {
        emit(BuildingError('Building not found'));
      }
    } catch (e) {
      emit(BuildingError('Failed to update building: $e'));
    }
  }

  /// Add new building to the stored list
  void addBuilding(BuildingEntity building) {
    _buildings.add(building);
    emit(Buildings(List.from(_buildings)));
  }

  /// Update an existing building in the stored list
  void updateBuilding(BuildingEntity updatedBuilding) {
    final index =
        _buildings.indexWhere((b) => b.globalId == updatedBuilding.globalId);
    if (index != -1) {
      _buildings[index] = updatedBuilding;
      emit(Buildings(List.from(_buildings)));
    }
  }

  /// Remove building from stored list
  void removeBuilding(String globalId) {
    _buildings.removeWhere((building) => building.globalId == globalId);
    emit(Buildings(List.from(_buildings)));
  }

  /// Select and load building details
  // Future<void> getBuildingDetails(String globalId, bool isOffline) async {
  //   emit(BuildingLoading());
  //   try {
  //     _selectedBuildingGlobalId =
  //         globalId.replaceAll('{', '').replaceAll('}', '');

  //     attributesCubit.showAttributes(true);
  //     await attributesCubit.showBuildingAttributes(_selectedBuildingGlobalId);

  //     emit(BuildingGlobalId(_selectedBuildingGlobalId));
  //   } catch (e) {
  //     emit(BuildingError(e.toString()));
  //   }
  // }

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

  // Future<void> startReviewing(String globalId, int value) async {
  //   emit(BuildingLoading());
  //   try {
  //     await buildingUseCases.startReviewing(globalId, value);
  //     emit(BuildingUpdateResponse(globalId));
  //   } catch (e) {
  //     emit(BuildingError(e.toString()));
  //   }
  // }

  /// Public getter for current globalId
  String? get globalId => _selectedBuildingGlobalId;

  /// Public method to manually set and emit globalId
  void selectBuildingByGlobalId(String? globalId) {
    _selectedBuildingGlobalId = globalId;
    emit(BuildingGlobalId(globalId));
  }

  Future<void> getBuildingsCount(
      LatLngBounds bounds, int municipalityId) async {
    emit(BuildingLoading());
    try {
      final count =
          await buildingUseCases.getBuildingsCount(bounds, municipalityId);
      emit(BuildingCount(count));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  void clearBuildings() {
    _selectedBuildingGlobalId = null;
    _buildings.clear(); // ✅ Clear stored buildings
    emit(Buildings([]));
  }

  // ✅ Public getter to access buildings anytime
  List<BuildingEntity> get buildings => List.unmodifiable(_buildings);

  // ✅ Check if we have buildings loaded
  bool get hasBuildings => _buildings.isNotEmpty;

  // ✅ Get specific building by globalId
  BuildingEntity? getBuildingByGlobalId(String globalId) {
    try {
      return _buildings.firstWhere((b) => b.globalId == globalId);
    } catch (e) {
      return null;
    }
  }

  // ✅ Get building count
  int get buildingCount => _buildings.length;

  // ✅ Get currently selected building
  BuildingEntity? get selectedBuilding {
    if (_selectedBuildingGlobalId == null) return null;
    return getBuildingByGlobalId(_selectedBuildingGlobalId!);
  }
}
