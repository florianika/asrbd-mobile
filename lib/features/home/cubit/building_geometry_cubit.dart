import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

// Import the actual BuildingEntity
import 'package:asrdb/domain/entities/building_entity.dart';

abstract class BuildingGeometryState {}

class BuildingGeometry extends BuildingGeometryState {
  final BuildingEntity? building;
  final bool isDrawing;
  final bool isMovingPoint;

  BuildingGeometry(this.building, this.isDrawing, this.isMovingPoint);
}

class BuildingGeometryCubit extends Cubit<BuildingGeometryState> {
  BuildingGeometryCubit() : super(BuildingGeometry(null, false, false));

  List<LatLng> _points = []; // Working with the main ring (first ring)
  BuildingEntity? _originalBuilding; // ✅ Store the original building
  bool _isDrawing = false;
  bool _isMovingPoint = false;

  final List<List<LatLng>> _undoStack = [];
  final List<List<LatLng>> _redoStack = [];

  void _emitCurrentState() {
    // Create a BuildingEntity with the current points
    final building = _originalBuilding != null
        ? _createUpdatedBuilding()
        : (_points.isNotEmpty
            ? BuildingEntity(
                objectId: 0, // Temporary ID for new buildings
                coordinates: [_points], // Wrap in outer list for polygon rings
              )
            : null);
    emit(BuildingGeometry(building, _isDrawing, _isMovingPoint));
  }

  // ✅ Create updated building with new coordinates but keeping original data
  BuildingEntity? _createUpdatedBuilding() {
    if (_originalBuilding == null) return null;

    return BuildingEntity(
      objectId: _originalBuilding!.objectId,
      featureId: _originalBuilding!.featureId,
      geometryType: _originalBuilding!.geometryType,
      coordinates: [_points], // Updated coordinates with current points
      shapeLength: _originalBuilding!.shapeLength,
      shapeArea: _originalBuilding!.shapeArea,
      globalId: _originalBuilding!.globalId,
      bldCensus2023: _originalBuilding!.bldCensus2023,
      bldQuality: _originalBuilding!.bldQuality,
      bldMunicipality: _originalBuilding!.bldMunicipality,
      bldEnumArea: _originalBuilding!.bldEnumArea,
      bldLatitude: _originalBuilding!.bldLatitude,
      bldLongitude: _originalBuilding!.bldLongitude,
      bldCadastralZone: _originalBuilding!.bldCadastralZone,
      bldProperty: _originalBuilding!.bldProperty,
      bldPermitNumber: _originalBuilding!.bldPermitNumber,
      bldPermitDate: _originalBuilding!.bldPermitDate,
      bldStatus: _originalBuilding!.bldStatus,
      bldYearConstruction: _originalBuilding!.bldYearConstruction,
      bldYearDemolition: _originalBuilding!.bldYearDemolition,
      bldType: _originalBuilding!.bldType,
      bldClass: _originalBuilding!.bldClass,
      bldArea: _originalBuilding!.bldArea,
      bldFloorsAbove: _originalBuilding!.bldFloorsAbove,
      bldHeight: _originalBuilding!.bldHeight,
      bldVolume: _originalBuilding!.bldVolume,
      bldWasteWater: _originalBuilding!.bldWasteWater,
      bldElectricity: _originalBuilding!.bldElectricity,
      bldPipedGas: _originalBuilding!.bldPipedGas,
      bldElevator: _originalBuilding!.bldElevator,
      createdUser: _originalBuilding!.createdUser,
      createdDate: _originalBuilding!.createdDate,
      lastEditedUser: _originalBuilding!.lastEditedUser,
      lastEditedDate: DateTime.now(), // ✅ Update timestamp
      bldCentroidStatus: _originalBuilding!.bldCentroidStatus,
      bldDwellingRecs: _originalBuilding!.bldDwellingRecs,
      bldEntranceRecs: _originalBuilding!.bldEntranceRecs,
      bldAddressID: _originalBuilding!.bldAddressID,
      externalCreator: _originalBuilding!.externalCreator,
      externalEditor: _originalBuilding!.externalEditor,
      bldReview: _originalBuilding!.bldReview,
      bldWaterSupply: _originalBuilding!.bldWaterSupply,
      externalCreatorDate: _originalBuilding!.externalCreatorDate,
      externalEditorDate: _originalBuilding!.externalEditorDate,
    );
  }

  // Set everything at once
  void setState({
    List<LatLng>? points,
    bool? isDrawing,
    bool? isMovingPoint,
    bool saveToUndo = true,
  }) {
    if (saveToUndo && (points != null && !_pointsEqual(points, _points))) {
      _pushToUndo();
      _redoStack.clear();
    }

    if (points != null) _points = List.from(points);
    if (isDrawing != null) _isDrawing = isDrawing;
    if (isMovingPoint != null) _isMovingPoint = isMovingPoint;

    _emitCurrentState();
  }

  // Set building with state flags
  void setBuilding(
    List<LatLng>? points, {
    bool isDrawing = false,
    bool isMovingPoint = false,
    bool saveToUndo = true,
  }) {
    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _points = points != null ? List.from(points) : [];
    _isDrawing = isDrawing;
    _isMovingPoint = isMovingPoint;

    _emitCurrentState();
  }

  // Set from existing BuildingEntity
  void setBuildingFromEntity(
    BuildingEntity? building, {
    bool isDrawing = false,
    bool isMovingPoint = false,
    bool saveToUndo = true,
  }) {
    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _originalBuilding = building; // ✅ Store the original building
    // Extract the first ring (main polygon) from coordinates
    _points = building?.coordinates.isNotEmpty == true
        ? List.from(building!.coordinates.first)
        : [];
    _isDrawing = isDrawing;
    _isMovingPoint = isMovingPoint;

    _emitCurrentState();
  }

  void addPoint(LatLng point, {bool saveToUndo = true}) {
    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    // Always treat as polygon since buildings are polygons
    GeometryHelper.injectPointIntoPolygon(_points, point);
    _emitCurrentState();
  }

  void removePoint(LatLng point, {bool saveToUndo = true}) {
    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _points.remove(point);
    _emitCurrentState();
  }

  /// Delete a point by index from the polygon
  /// Returns true if deletion was successful, false if polygon would have < 4 points
  bool deletePointByIndex(int index, {bool saveToUndo = true}) {
    // Polygon must have at least 4 points (minimum is 3 for a valid polygon + 1 closing point)
    if (_points.length <= 4) {
      return false;
    }

    if (index < 0 || index >= _points.length) {
      return false;
    }

    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _points.removeAt(index);
    _emitCurrentState();
    return true;
  }

  /// Delete a point by position (LatLng) from the polygon
  /// Returns true if deletion was successful, false if polygon would have < 4 points or point not found
  bool deletePointByPosition(LatLng position, {bool saveToUndo = true}) {
    final index = _points.indexWhere((point) =>
        (point.latitude - position.latitude).abs() < 0.0001 &&
        (point.longitude - position.longitude).abs() < 0.0001);

    if (index == -1) {
      return false; // Point not found
    }

    return deletePointByIndex(index, saveToUndo: saveToUndo);
  }

  void updatePointPosition(int index, LatLng newPosition,
      {bool saveToUndo = true}) {
    if (index < 0 || index >= _points.length) return;

    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _points[index] = newPosition;
    _emitCurrentState();
  }

  void updatePointByPosition(LatLng oldPosition, LatLng newPosition,
      {bool saveToUndo = true}) {
    final index = _points.indexWhere((point) =>
        (point.latitude - oldPosition.latitude).abs() < 0.0001 &&
        (point.longitude - oldPosition.longitude).abs() < 0.0001);

    if (index != -1) {
      updatePointPosition(index, newPosition, saveToUndo: saveToUndo);
    }
  }

  void clearPoints({bool saveToUndo = true}) {
    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _originalBuilding = null; // ✅ Clear original building too
    _points.clear();
    _emitCurrentState();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(List.from(_points));
    _points = _undoStack.removeLast();
    _emitCurrentState();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(List.from(_points));
    _points = _redoStack.removeLast();
    _emitCurrentState();
  }

  void _pushToUndo() {
    _undoStack.add(List.from(_points));
  }

  // Helper method to compare point lists
  bool _pointsEqual(List<LatLng> a, List<LatLng> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if ((a[i].latitude - b[i].latitude).abs() > 0.0001 ||
          (a[i].longitude - b[i].longitude).abs() > 0.0001) {
        return false;
      }
    }
    return true;
  }

  void setDrawing(bool isDrawing) {
    _isDrawing = isDrawing;
    _emitCurrentState();
  }

  // ✅ Missing method that EditBuildingMarker needs
  void setMovingPoint(bool isMovingPoint) {
    _isMovingPoint = isMovingPoint;
    _emitCurrentState();
  }

  // Getters
  List<LatLng> get points => List.unmodifiable(_points);
  bool get isDrawing => _isDrawing;
  bool get isMovingPoint => _isMovingPoint;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get hasPoints => _points.isNotEmpty;
  int get pointCount => _points.length;

  // ✅ Additional getters
  BuildingEntity? get originalBuilding => _originalBuilding;
  BuildingEntity? get currentBuilding {
    final currentState = state;
    return currentState is BuildingGeometry ? currentState.building : null;
  }

  bool get isEditingExisting => _originalBuilding != null;
}
