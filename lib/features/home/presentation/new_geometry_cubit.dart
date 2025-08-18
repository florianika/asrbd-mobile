import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

/// State
abstract class NewGeometryState {}

class NewGeometry extends NewGeometryState {
  final List<LatLng> points;
  final ShapeType type;
  final bool isDrawing;
  final bool isMovingPoint;
  NewGeometry(this.points, this.type, this.isDrawing, this.isMovingPoint);
}

/// Cubit
class NewGeometryCubit extends Cubit<NewGeometryState> {
  NewGeometryCubit() : super(NewGeometry([], ShapeType.point, false, false));

  List<LatLng> _points = [];
  ShapeType _type = ShapeType.point;
  bool _isDrawing = false;
  bool _isMovingPoint = false;

  final List<List<LatLng>> _undoStack = [];
  final List<List<LatLng>> _redoStack = [];

  void _emitCurrentState() {
    emit(NewGeometry(List.from(_points), _type, _isDrawing, _isMovingPoint));
  }

  void setDrawing(bool isDrawing) {
    _isDrawing = isDrawing;
    _emitCurrentState();
  }

  void setMovingPoint(bool isMovingPoint) {
    _isMovingPoint = isMovingPoint;
    _emitCurrentState();
  }

  void setType(ShapeType type) {
    _type = type;
    _emitCurrentState();
  }

  void addPoint(LatLng point) {
    _pushToUndo();
    _redoStack.clear();

    if (_type == ShapeType.polygon) {
      GeometryHelper.injectPointIntoPolygon(_points, point);     
    } else {
      _points.add(point);
    }
    _emitCurrentState();
  }

  void removePoint(LatLng point) {
    _pushToUndo();
    _redoStack.clear();

    _points.remove(point);
    _emitCurrentState();
  }

  void setPoints(List<LatLng> points, {ShapeType? type}) {
    _pushToUndo();
    _redoStack.clear();

    _points = List.from(points);
    if (type != null) _type = type;
    _emitCurrentState();
  }

  void clearPoints() {
    _pushToUndo();
    _redoStack.clear();

    _points.clear();
    _emitCurrentState();
  }

  // NEW METHOD: Update a specific point position by index
  void updatePointPosition(int index, LatLng newPosition) {
    if (index < 0 || index >= _points.length) return;

    _pushToUndo();
    _redoStack.clear();

    _points[index] = newPosition;
    _emitCurrentState();
  }

  // NEW METHOD: Update a point by finding its current position
  void updatePointByPosition(LatLng oldPosition, LatLng newPosition) {
    final index = _points.indexWhere((point) =>
        (point.latitude - oldPosition.latitude).abs() < 0.0001 &&
        (point.longitude - oldPosition.longitude).abs() < 0.0001);

    if (index != -1) {
      updatePointPosition(index, newPosition);
    }
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

  List<LatLng> get points => List.unmodifiable(_points);
  ShapeType get type => _type;
  bool get isDrawing => _isDrawing;
  bool get isMovingPoint => _isMovingPoint;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
}
