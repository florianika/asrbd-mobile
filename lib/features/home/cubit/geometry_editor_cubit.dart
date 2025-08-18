import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

// Import your existing cubits
import 'entrance_geometry_cubit.dart';
import 'building_geometry_cubit.dart';

// Import your entities
import 'package:asrdb/domain/entities/building_entity.dart';
// import 'package:asrdb/domain/entities/entrance_entity.dart'; // Adjust path

enum EntityType { entrance, building, none }

enum EditorMode { view, edit, create }

abstract class GeometryEditorState {}

class GeometryEditorIdle extends GeometryEditorState {
  final EntityType selectedType;
  final EditorMode mode;
  final bool showAdditionalUI;

  GeometryEditorIdle({
    this.selectedType = EntityType.none,
    this.mode = EditorMode.view,
    this.showAdditionalUI = false,
  });
}

class GeometryEditorCubit extends Cubit<GeometryEditorState> {
  final EntranceGeometryCubit entranceCubit;
  final BuildingGeometryCubit buildingCubit;

  GeometryEditorCubit({
    required this.entranceCubit,
    required this.buildingCubit,
  }) : super(GeometryEditorIdle());

  EntityType _selectedType = EntityType.none;
  EditorMode _mode = EditorMode.view;
  bool _showAdditionalUI = false;

  // Handle long press on entrance
  void onEntranceLongPress(EntranceEntity entrance) {
    _selectedType = EntityType.entrance;
    _mode = EditorMode.edit;
    _showAdditionalUI = true;

    // Set the entrance cubit to edit mode
    entranceCubit.setEntrance(
      entrance,
      isDrawing: false,
      isMovingPoint: true,
    );

    // Reset building cubit
    buildingCubit.setState(
      points: [],
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

  // Handle long press on building
  void onBuildingLongPress(BuildingEntity building) {
    _selectedType = EntityType.building;
    _mode = EditorMode.edit;
    _showAdditionalUI = true;

    // Set the building cubit to edit mode
    buildingCubit.setBuildingFromEntity(
      building,
      isDrawing: false,
      isMovingPoint: true,
    );

    // Reset entrance cubit
    entranceCubit.setState(
      point: null,
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

  // Start creating new entrance
  void startCreatingEntrance() {
    _selectedType = EntityType.entrance;
    _mode = EditorMode.create;
    _showAdditionalUI = true;

    entranceCubit.setState(
      point: null,
      isDrawing: true,
      isMovingPoint: false,
    );

    buildingCubit.setState(
      points: [],
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

  // Start creating new building
  void startCreatingBuilding() {
    _selectedType = EntityType.building;
    _mode = EditorMode.create;
    _showAdditionalUI = true;

    buildingCubit.setState(
      points: [],
      isDrawing: true,
      isMovingPoint: false,
    );

    entranceCubit.setState(
      point: null,
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

  // Handle map tap during creation
  void onMapTap(LatLng point) {
    if (_mode == EditorMode.create) {
      if (_selectedType == EntityType.entrance) {
        entranceCubit.addPoint(point);
        // Automatically finish entrance creation after adding point
        finishCreation();
      } else if (_selectedType == EntityType.building) {
        buildingCubit.addPoint(point);
      }
    }
  }

  // Finish creation mode
  void finishCreation() {
    if (_selectedType == EntityType.entrance) {
      entranceCubit.setDrawing(false);
    } else if (_selectedType == EntityType.building) {
      buildingCubit.setDrawing(false);
    }

    _mode = EditorMode.edit;
    _emitCurrentState();
  }

  // Cancel current operation
  void cancelOperation() {
    _selectedType = EntityType.none;
    _mode = EditorMode.view;
    _showAdditionalUI = false;

    // Reset both cubits
    entranceCubit.setState(
      point: null,
      isDrawing: false,
      isMovingPoint: false,
    );

    buildingCubit.setState(
      points: [],
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

  // Save current changes
  void saveChanges() {
    // Here you would typically save to your repository
    // Then reset the UI
    entranceCubit.clearPoints();
    _mode = EditorMode.view;
    _showAdditionalUI = false;
    _emitCurrentState();
  }

  // Toggle additional UI visibility
  void toggleAdditionalUI() {
    _showAdditionalUI = !_showAdditionalUI;
    _emitCurrentState();
  }

  // Delete selected entity
  void deleteSelected() {
    if (_selectedType == EntityType.entrance) {
      entranceCubit.clearPoints();
    } else if (_selectedType == EntityType.building) {
      buildingCubit.clearPoints();
    }

    cancelOperation();
  }

  // Undo last operation
  void undo() {
    if (_selectedType == EntityType.entrance && entranceCubit.canUndo) {
      entranceCubit.undo();
    } else if (_selectedType == EntityType.building && buildingCubit.canUndo) {
      buildingCubit.undo();
    }
  }

  // Redo last operation
  void redo() {
    if (_selectedType == EntityType.entrance && entranceCubit.canRedo) {
      entranceCubit.redo();
    } else if (_selectedType == EntityType.building && buildingCubit.canRedo) {
      buildingCubit.redo();
    }
  }

  void _emitCurrentState() {
    emit(GeometryEditorIdle(
      selectedType: _selectedType,
      mode: _mode,
      showAdditionalUI: _showAdditionalUI,
    ));
  }

  // Getters
  EntityType get selectedType => _selectedType;
  EditorMode get mode => _mode;
  bool get showAdditionalUI => _showAdditionalUI;
  bool get isEditing => _mode != EditorMode.view;  
  bool get canUndo => _selectedType == EntityType.entrance
      ? entranceCubit.canUndo
      : buildingCubit.canUndo;
  bool get canRedo => _selectedType == EntityType.entrance
      ? entranceCubit.canRedo
      : buildingCubit.canRedo;
}
