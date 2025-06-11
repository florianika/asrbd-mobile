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
  final String globalId;

  Attributes(
    this.schema,
    this.initialData,
    this.shapeType,
    this.globalId, {
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

  AttributesCubit(
    this.entranceUseCases,
    this.buildingUseCases,
    this.dwellingUseCases,
  ) : super(AttributesVisibility(false));

  void showAttributes(bool showAttributes) {
    emit(AttributesVisibility(showAttributes));
  }

  Future<void> showDwellingAttributes(int? objectId) async {
    emit(AttributesLoading());
    try {
      final schema = await dwellingUseCases.getDwellingAttibutes();
      if (objectId == null) {
        emit(Attributes(schema, {}, ShapeType.noShape, '', viewDwelling: true));
        return;
      }

      final dwellingData = await dwellingUseCases.getDwellingDetails(objectId);
      if (dwellingData.isNotEmpty) {
        final features = dwellingData['features'];
        emit(Attributes(schema, features[0]['properties'], ShapeType.noShape, '',
            viewDwelling: true));
      } else {
        emit(Attributes(schema, {}, ShapeType.point, '', viewDwelling: true));
      }
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showEntranceAttributes(String? globalID) async {
    emit(AttributesLoading());
    try {
      final schema = await entranceUseCases.getEntranceAttributes();
      if (globalID == null) {
        emit(Attributes(schema, {}, ShapeType.point, globalID ?? ''));
        return;
      }

      final entranceData = await entranceUseCases.getEntranceDetails(globalID);
      if (entranceData.isNotEmpty) {
        final features = entranceData['features'];
        emit(Attributes(
            schema, features[0]['properties'], ShapeType.point, globalID));
      } else {
        emit(Attributes(schema, {}, ShapeType.point, globalID));
      }
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showBuildingAttributes(String? globalID) async {
    emit(AttributesLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      if (globalID == null) {
        emit(Attributes(schema, {}, ShapeType.polygon, globalID ?? ''));
        return;
      }

      final buildingData = await buildingUseCases.getBuildingDetails(globalID);
      if (buildingData.isNotEmpty) {
        final features = buildingData['features'];
        emit(Attributes(
            schema, features[0]['properties'], ShapeType.polygon, globalID));
      } else {
        emit(Attributes(schema, {}, ShapeType.point, globalID));
      }
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  String? get currentGlobalId {
    final currentState = state;
    if (currentState is Attributes) {
      return currentState.globalId;
    }
    return null;
  }
}
