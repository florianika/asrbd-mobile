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
  List<BuildingEntity> _buildings = [];
  List<BuildingEntity> _allBuildings = []; // Store original unfiltered buildings
  Set<String> _selectedLegendLabels = {};
  String? _currentAttribute;

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
          bounds, zoom, municipalityId, isOffline, downloadId);
      _allBuildings = List.from(buildings); // Store original copy
      _buildings = _applyFilters(_allBuildings); // Apply existing filters
      emit(Buildings(_buildings));
    } catch (e) {
      emit(BuildingError(e.toString()));
    }
  }

  /// Update building coordinates
  Future<void> updateBuildingCoordinates(BuildingEntity building) async {
    if (_buildings.isEmpty) return;

    emit(BuildingLoading());

    try {
      final buildings = List<BuildingEntity>.from(_buildings);
      final buildingIndex =
          buildings.indexWhere((b) => b.globalId == building.globalId);

      if (buildingIndex != -1) {
        buildings[buildingIndex] = building;
        _buildings = buildings;
        
        // Also update in the original list
        final allBuildingsIndex =
            _allBuildings.indexWhere((b) => b.globalId == building.globalId);
        if (allBuildingsIndex != -1) {
          _allBuildings[allBuildingsIndex] = building;
        }
        
        emit(Buildings(buildings));
      } else {
        emit(BuildingError('Building not found'));
      }
    } catch (e) {
      emit(BuildingError('Failed to update building: $e'));
    }
  }

  /// Filter buildings by selected legends
  void filterBuildingsByLegends(
      Set<String> selectedLegendLabels, String currentAttribute) {
    _selectedLegendLabels = selectedLegendLabels;
    _currentAttribute = currentAttribute;
    
    _buildings = _applyFilters(_allBuildings);
    emit(Buildings(List.from(_buildings)));
  }

  /// Apply current filters to a list of buildings
  List<BuildingEntity> _applyFilters(List<BuildingEntity> buildings) {
    if (_selectedLegendLabels.isEmpty || _currentAttribute == null) {
      return List.from(buildings);
    }

    List<BuildingEntity> filtered = [];

    if (_currentAttribute == "quality") {
      filtered = buildings
          .where((building) =>
              _selectedLegendLabels.contains(building.bldQuality.toString()))
          .toList();
    } else if (_currentAttribute == "review") {
      filtered = buildings
          .where((building) =>
              _selectedLegendLabels.contains(building.bldReview.toString()))
          .toList();
    } else if (_currentAttribute == "status") {
      filtered = buildings
          .where((building) =>
              _selectedLegendLabels.contains(building.bldStatus.toString()))
          .toList();
    } else if (_currentAttribute == "centroidStatus") {
      filtered = buildings
          .where((building) => _selectedLegendLabels
              .contains(building.bldCentroidStatus.toString()))
          .toList();
    } else {
      filtered = List.from(buildings);
    }

    return filtered;
  }

  /// Clear all filters and restore original buildings
  void clearFilters() {
    _selectedLegendLabels.clear();
    _currentAttribute = null;
    _buildings = List.from(_allBuildings);
    emit(Buildings(List.from(_buildings)));
  }

  /// Add new building to the stored list
  void addBuilding(BuildingEntity building) {
    _buildings.add(building);
    _allBuildings.add(building); // Add to original list too
    emit(Buildings(List.from(_buildings)));
  }

  /// Update an existing building in the stored list
  void updateBuilding(BuildingEntity updatedBuilding) {
    final index =
        _buildings.indexWhere((b) => b.globalId == updatedBuilding.globalId);
    if (index != -1) {
      _buildings[index] = updatedBuilding;
    }
    
    // Also update in original list
    final allIndex =
        _allBuildings.indexWhere((b) => b.globalId == updatedBuilding.globalId);
    if (allIndex != -1) {
      _allBuildings[allIndex] = updatedBuilding;
    }
    
    emit(Buildings(List.from(_buildings)));
  }

  /// Remove building from stored list
  void removeBuilding(String globalId) {
    _buildings.removeWhere((building) => building.globalId == globalId);
    _allBuildings.removeWhere((building) => building.globalId == globalId);
    emit(Buildings(List.from(_buildings)));
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
    _buildings.clear();
    _allBuildings.clear(); // Clear both lists
    _selectedLegendLabels.clear();
    _currentAttribute = null;
    emit(Buildings([]));
  }

  // Public getter to access buildings anytime
  List<BuildingEntity> get buildings => List.unmodifiable(_buildings);

  // Get all buildings (unfiltered)
  List<BuildingEntity> get allBuildings => List.unmodifiable(_allBuildings);

  // Check if we have buildings loaded
  bool get hasBuildings => _buildings.isNotEmpty;

  // Check if filters are active
  bool get hasActiveFilters => _selectedLegendLabels.isNotEmpty;

  // Get specific building by globalId
  BuildingEntity? getBuildingByGlobalId(String globalId) {
    try {
      return _buildings.firstWhere((b) => b.globalId == globalId);
    } catch (e) {
      return null;
    }
  }

  // Get building count (filtered)
  int get buildingCount => _buildings.length;

  // Get total building count (unfiltered)
  int get totalBuildingCount => _allBuildings.length;

  // Get currently selected building
  BuildingEntity? get selectedBuilding {
    if (_selectedBuildingGlobalId == null) return null;
    return getBuildingByGlobalId(_selectedBuildingGlobalId!);
  }
}