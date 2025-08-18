import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

abstract class EntranceGeometryState {}

class EntranceGeometry extends EntranceGeometryState {
  final EntranceEntity? entrance;
  final bool isDrawing;
  final bool isMovingPoint;

  EntranceGeometry(this.entrance, this.isDrawing, this.isMovingPoint);
}

class EntranceGeometryCubit extends Cubit<EntranceGeometryState> {
  EntranceGeometryCubit() : super(EntranceGeometry(null, false, false));

  LatLng? _point;
  EntranceEntity? _originalEntrance; // ✅ Store the original entrance
  ShapeType _type = ShapeType.point;
  bool _isDrawing = false;
  bool _isMovingPoint = false;

  final List<LatLng?> _undoStack = [];
  final List<LatLng?> _redoStack = [];

  void _emitCurrentState() {
    // Create entrance based on original or new point
    final entrance = _originalEntrance != null
        ? _createUpdatedEntrance()
        : (_point != null ? EntranceEntity(coordinates: _point!) : null);

    emit(EntranceGeometry(entrance, _isDrawing, _isMovingPoint));
  }

  // ✅ Create updated entrance with new coordinates but keeping original data
  EntranceEntity? _createUpdatedEntrance() {
    if (_originalEntrance == null) return null;

    // If your EntranceEntity has a copyWith method, use it:
    // return _originalEntrance!.copyWith(coordinates: _point);

    // Otherwise, create new entrance with original data:

    return _originalEntrance!.copyWith(coordinates: _point);
  }

  void setDrawing(bool isDrawing) {
    _isDrawing = isDrawing;
    _emitCurrentState();
  }

  void setMovingPoint(bool isMovingPoint) {
    _isMovingPoint = isMovingPoint;
    _isDrawing = true;
    _emitCurrentState();
  }

  void setType(ShapeType type) {
    _type = type;
    _emitCurrentState();
  }

  // Set everything at once
  void setState({
    LatLng? point,
    bool? isDrawing,
    bool? isMovingPoint,
    ShapeType? type,
    bool saveToUndo = true,
  }) {
    if (saveToUndo && point != _point) {
      _pushToUndo();
      _redoStack.clear();
    }

    if (point != null) _point = point;
    if (isDrawing != null) _isDrawing = isDrawing;
    if (isMovingPoint != null) _isMovingPoint = isMovingPoint;
    if (type != null) _type = type;

    _emitCurrentState();
  }

  // ✅ Set entrance with state flags - now stores the original entrance
  void setEntrance(
    EntranceEntity? entrance, {
    bool isDrawing = false,
    bool isMovingPoint = false,
    bool saveToUndo = true,
  }) {
    if (saveToUndo) {
      _pushToUndo();
      _redoStack.clear();
    }

    _originalEntrance = entrance; // ✅ Store the original entrance
    _point = entrance?.coordinates;
    _isDrawing = isDrawing;
    _isMovingPoint = isMovingPoint;

    _emitCurrentState();
  }

  void addPoint(LatLng point) {
    _pushToUndo();
    _redoStack.clear();

    _point = point;
    _emitCurrentState();
  }

  void updatePoint(LatLng point) {
    // For updating existing point during movement
    _point = point;
    _emitCurrentState();
  }

  void removePoint(LatLng point) {
    _pushToUndo();
    _redoStack.clear();

    _point = null;
    _emitCurrentState();
  }

  void clearPoints() {
    _pushToUndo();
    _redoStack.clear();

    _originalEntrance = null; // ✅ Clear original entrance too
    _point = null;
    _emitCurrentState();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(_point);
    _point = _undoStack.removeLast();
    _emitCurrentState();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(_point);
    _point = _redoStack.removeLast();
    _emitCurrentState();
  }

  void _pushToUndo() {
    _undoStack.add(_point);
  }

  // Getters
  LatLng? get point => _point;
  ShapeType get type => _type;
  bool get isDrawing => _isDrawing;
  bool get isMovingPoint => _isMovingPoint;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get hasPoint => _point != null;

  // ✅ Get the original entrance that was provided
  EntranceEntity? get originalEntrance => _originalEntrance;

  // ✅ Get the current entrance (with updated coordinates)
  EntranceEntity? get currentEntrance {
    final currentState = state;
    return currentState is EntranceGeometry ? currentState.entrance : null;
  }

  // ✅ Check if we're editing an existing entrance vs creating new
  bool get isEditingExisting => _originalEntrance != null;
}
