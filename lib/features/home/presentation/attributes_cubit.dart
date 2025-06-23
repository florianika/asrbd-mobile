import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AttributesState {}

class AttributesInitial extends AttributesState {}

class AttributesLoading extends AttributesState {}

class Attributes extends AttributesState {
  final List<FieldSchema> schema;
  final Map<String, dynamic> initialData;
  final ShapeType shapeType;
  final bool viewDwelling;
  final String? buildingGlobalId;
  final String? entranceGlobalId;
  final int? dwellingObjectId;

  Attributes(
    this.schema,
    this.initialData,
    this.shapeType,
    this.buildingGlobalId,
    this.entranceGlobalId,
    this.dwellingObjectId, {
    this.viewDwelling = false,
  });
}

class AttributesError extends AttributesState {
  final String message;
  AttributesError(this.message);
}

class AttributesVisibility extends AttributesState {
  final bool showAttributes;
  AttributesVisibility(this.showAttributes);
}

class AttributesCubit extends Cubit<AttributesState> {
  final EntranceUseCases entranceUseCases;
  final BuildingUseCases buildingUseCases;
  final DwellingUseCases dwellingUseCases;

  bool showLoading = true;

  AttributesCubit(
    this.entranceUseCases,
    this.buildingUseCases,
    this.dwellingUseCases,
  ) : super(AttributesVisibility(false));

  void setShowLoading(bool value) {
    showLoading = value;
  }

  void showAttributes(bool showAttributes) {
    if (!showAttributes) {
      emit(Attributes([], {}, ShapeType.point, null, null, null));
    }
    emit(AttributesVisibility(showAttributes));
  }

  Future<void> showDwellingAttributes(int? dwellingObjectID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await dwellingUseCases.getDwellingAttibutes();
      if (dwellingObjectID == null) {
        emit(Attributes(
            schema, {}, ShapeType.noShape, null, null, dwellingObjectID,
            viewDwelling: true));
        return;
      }

      final dwellingData =
          await dwellingUseCases.getDwellingDetails(dwellingObjectID);
      if (dwellingData.isNotEmpty) {
        final features = dwellingData['features'];
        emit(Attributes(schema, features[0]['properties'], ShapeType.noShape,
            null, null, dwellingObjectID,
            viewDwelling: true));
      } else {
        emit(Attributes(
            schema, {}, ShapeType.point, null, null, dwellingObjectID,
            viewDwelling: true));
      }
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showEntranceAttributes(
      String? entranceGlobalID, String? buildingGlobalID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await entranceUseCases.getEntranceAttributes();
      if (entranceGlobalID == null) {
        emit(Attributes(schema, {'EntBldGlobalID': buildingGlobalID},
            ShapeType.point, buildingGlobalID, entranceGlobalID, null));
        return;
      }

      final entranceData =
          await entranceUseCases.getEntranceDetails(entranceGlobalID);
      if (entranceData.isNotEmpty) {
        final features = entranceData['features'];
        emit(Attributes(
            schema,
            features[0]['properties'],
            ShapeType.point,
            features[0]['properties']['EntBldGlobalID'],
            entranceGlobalID,
            null));
      } else {
        emit(Attributes(schema, {}, ShapeType.point, buildingGlobalID,
            entranceGlobalID, null));
      }
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showBuildingAttributes(String? buildingGlobalID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      if (buildingGlobalID == null) {
        emit(Attributes(
            schema, {}, ShapeType.polygon, buildingGlobalID, null, null));
        return;
      }

      final buildingData =
          await buildingUseCases.getBuildingDetails(buildingGlobalID);
      if (buildingData.isNotEmpty) {
        final features = buildingData['features'];
        emit(Attributes(schema, features[0]['properties'], ShapeType.polygon,
            buildingGlobalID, null, null));
      } else {
        emit(Attributes(
            schema, {}, ShapeType.polygon, buildingGlobalID, null, null));
      }
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  String? get currentBuildingGlobalId {
    final currentState = state;
    if (currentState is Attributes) {
      return currentState.buildingGlobalId;
    }
    return null;
  }

  String? get currentEntranceGlobalId {
    final currentState = state;
    if (currentState is Attributes) {
      return currentState.entranceGlobalId;
    }
    return null;
  }

  int? get currentDwellingObjectId {
    final currentState = state;
    if (currentState is Attributes) {
      return currentState.dwellingObjectId;
    }
    return null;
  }

  ShapeType get shapeType {
    final currentState = state;
    if (currentState is Attributes) {
      return currentState.shapeType;
    }
    return ShapeType.point;
  }
}
