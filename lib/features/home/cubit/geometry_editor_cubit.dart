import 'dart:async';

import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

// Import your existing cubits
import 'entrance_geometry_cubit.dart';
import 'building_geometry_cubit.dart';

// Import your entities
import 'package:asrdb/domain/entities/building_entity.dart';

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
  // ✅ Public access to cubits as you requested
  final EntranceGeometryCubit entranceCubit;
  final BuildingGeometryCubit buildingCubit;

  late final StreamSubscription _entranceSubscription;
  late final StreamSubscription _buildingSubscription;

  GeometryEditorCubit({
    required this.entranceCubit,
    required this.buildingCubit,
  }) : super(GeometryEditorIdle()) {
    // Listen to entrance cubit changes
    _entranceSubscription = entranceCubit.stream.listen((_) {
      if (_selectedType == EntityType.entrance) {
        _emitCurrentState();
      }
    });

    _buildingSubscription = buildingCubit.stream.listen((_) {
      if (_selectedType == EntityType.building) {
        _emitCurrentState();
      }
    });
  }

  @override
  Future<void> close() {
    _entranceSubscription.cancel();
    _buildingSubscription.cancel();
    return super.close();
  }

  EntityType _selectedType = EntityType.none;
  EditorMode _mode = EditorMode.view;
  bool _showAdditionalUI = false;

  void onEntranceLongPress(EntranceEntity entrance) {
    _selectedType = EntityType.entrance;
    _mode = EditorMode.edit;
    _showAdditionalUI = true;

    entranceCubit.setEntrance(
      entrance,
      isDrawing: false,
      isMovingPoint: true,
    );

    buildingCubit.setState(
      points: [],
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

  void onBuildingLongPress(BuildingEntity building) {
    _selectedType = EntityType.building;
    _mode = EditorMode.edit;
    _showAdditionalUI = true;

    buildingCubit.setBuildingFromEntity(
      building,
      isDrawing: false,
      isMovingPoint: true,
    );

    entranceCubit.setState(
      point: null,
      isDrawing: false,
      isMovingPoint: false,
    );

    _emitCurrentState();
  }

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

  void onMapTap(LatLng point) {
    if (_mode == EditorMode.create) {
      if (_selectedType == EntityType.entrance) {
        entranceCubit.addPoint(point);
        finishCreation();
      }
      // Building vertices are now only added by dragging, not by tapping
    }
  }

  Future<void> onMapTapWithValidation(
    LatLng point,
    String? buildingGlobalId,
    bool isOffline,
    int? downloadId,
  ) async {
    if (_mode == EditorMode.create) {
      if (_selectedType == EntityType.entrance && buildingGlobalId != null) {
        await entranceCubit.addPointWithValidation(
          point,
          buildingGlobalId,
          isOffline,
          downloadId,
        );
        finishCreation();
      } else if (_selectedType == EntityType.building) {
        buildingCubit.addPoint(point);
      }
    }
  }

  void updateEntrancePoint(LatLng newPoint) {
    if (_selectedType == EntityType.entrance) {
      entranceCubit.updatePoint(newPoint);
    }
  }

  Future<void> updateEntrancePointWithValidation(
    LatLng newPoint,
    String? buildingGlobalId,
    bool isOffline,
    int? downloadId,
  ) async {
    if (_selectedType == EntityType.entrance && buildingGlobalId != null) {
      await entranceCubit.updatePointWithValidation(
        newPoint,
        buildingGlobalId,
        isOffline,
        downloadId,
      );
    }
  }

  void updateBuildingPoint(int index, LatLng newPoint,
      {bool saveToUndo = true}) {
    if (_selectedType == EntityType.building) {
      buildingCubit.updatePointPosition(index, newPoint,
          saveToUndo: saveToUndo);
    }
  }

  void setEntranceMoving(bool isMoving) {
    if (_selectedType == EntityType.entrance) {
      entranceCubit.setMovingPoint(isMoving);
    }
  }

  // ✅ Counter getter - dynamic calculation based on current state
  int get currentCounter {
    if (_selectedType == EntityType.entrance) {
      return entranceCubit.hasPoint ? 1 : 0;
    } else if (_selectedType == EntityType.building) {
      return buildingCubit.pointCount;
    }
    return 0;
  }

  // ✅ Save button enabled state
  bool get canSave {
    if (_selectedType == EntityType.entrance) {
      return currentCounter == 1;
    } else if (_selectedType == EntityType.building) {
      return currentCounter > 2;
    }
    return false;
  }

  // ✅ Pin/Add point button enabled state
  bool get canAddPoint {
    if (_selectedType == EntityType.building) {
      return true; // Can always add points to building
    } else if (_selectedType == EntityType.entrance) {
      return currentCounter == 0; // Can only add point if no point exists
    }
    return false;
  }

  // ✅ Alternative getter if you prefer explicit entrance counter
  int get entranceCounter => entranceCubit.hasPoint ? 1 : 0;

  // ✅ Alternative getter if you prefer explicit building counter
  int get buildingCounter => buildingCubit.pointCount;

  void setBuildingMoving(bool isMoving) {
    if (_selectedType == EntityType.building) {
      buildingCubit.setMovingPoint(isMoving);
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
    buildingCubit.clearPoints();
    _selectedType = EntityType.none;
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
  bool get isDrawing => _selectedType == EntityType.entrance
      ? entranceCubit.isDrawing
      : buildingCubit.isDrawing;
  bool get canUndo => _selectedType == EntityType.entrance
      ? entranceCubit.canUndo
      : buildingCubit.canUndo;
  bool get canRedo => _selectedType == EntityType.entrance
      ? entranceCubit.canRedo
      : buildingCubit.canRedo;

  // ✅ Additional convenience getters
  LatLng? get currentEntrancePoint =>
      _selectedType == EntityType.entrance ? entranceCubit.point : null;

  List<LatLng> get currentBuildingPoints =>
      _selectedType == EntityType.building ? buildingCubit.points : [];

  bool get hasValidGeometry => _selectedType == EntityType.entrance
      ? entranceCubit.hasPoint
      : buildingCubit.hasPoints;

  int get buildingPointCount =>
      _selectedType == EntityType.building ? buildingCubit.pointCount : 0;
}
