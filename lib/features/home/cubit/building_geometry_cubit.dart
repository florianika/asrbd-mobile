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
  bool _isDrawing = false;
  bool _isMovingPoint = false;

  final List<List<LatLng>> _undoStack = [];
  final List<List<LatLng>> _redoStack = [];

  void _emitCurrentState() {
    // Create a BuildingEntity with the current points
    final building = _points.isNotEmpty
        ? BuildingEntity(
            objectId: 0, // Temporary ID for new buildings
            coordinates: [_points], // Wrap in outer list for polygon rings
          )
        : null;
    emit(BuildingGeometry(building, _isDrawing, _isMovingPoint));
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

  // Getters
  List<LatLng> get points => List.unmodifiable(_points);
  bool get isDrawing => _isDrawing;
  bool get isMovingPoint => _isMovingPoint;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get hasPoints => _points.isNotEmpty;
  int get pointCount => _points.length;
}
