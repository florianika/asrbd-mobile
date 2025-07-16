import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';

abstract class AttributesState extends Equatable {
  @override
  List<Object?> get props => [];
}

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

  @override
  List<Object?> get props => [
        schema,
        initialData,
        shapeType,
        buildingGlobalId,
        entranceGlobalId,
        dwellingObjectId,
        viewDwelling,
      ];
}

class AttributesError extends AttributesState {
  final String message;
  AttributesError(this.message);

  @override
  List<Object?> get props => [message];
}

class AttributesVisibility extends AttributesState {
  final bool showAttributes;
  AttributesVisibility(this.showAttributes);

  @override
  List<Object?> get props => [showAttributes];
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
      emit(Attributes(const [], const {}, ShapeType.point, null, null, null));
    }
    emit(AttributesVisibility(showAttributes));
  }

  Future<void> setCurrentBuildingGlobalId(String? buildingGlobalID) async {
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      if (buildingGlobalID == null) {
        emit(Attributes(schema, const {}, ShapeType.polygon, null, null, null));
        return;
      }

      final data = await buildingUseCases.getBuildingDetails(buildingGlobalID);
      final features = data['features'] ?? [];
      final props = features.isNotEmpty ? features[0]['properties'] : {};
      emit(Attributes(
          schema, props, ShapeType.polygon, buildingGlobalID, null, null));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showDwellingAttributes(int? dwellingObjectID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await dwellingUseCases.getDwellingAttibutes();
      if (dwellingObjectID == null) {
        emit(Attributes(schema, {}, ShapeType.noShape, null, null, null,
            viewDwelling: true));
        return;
      }

      final data = await dwellingUseCases.getDwellingDetails(dwellingObjectID);
      final features = data['features'] ?? [];
      final props = features.isNotEmpty ? features[0]['properties'] : {};
      emit(Attributes(
        schema,
        props,
        ShapeType.noShape,
        null,
        null,
        dwellingObjectID,
        viewDwelling: true,
      ));
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

      final data = await entranceUseCases.getEntranceDetails(entranceGlobalID);
      final features = data['features'] ?? [];
      final props = features.isNotEmpty ? features[0]['properties'] : {};
      emit(Attributes(
        schema,
        props,
        ShapeType.point,
        props['EntBldGlobalID'] ?? buildingGlobalID,
        entranceGlobalID,
        null,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showBuildingAttributes(String? buildingGlobalID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      if (buildingGlobalID == null) {
        emit(Attributes(schema, const {}, ShapeType.polygon, null, null, null));
        return;
      }

      final data = await buildingUseCases.getBuildingDetails(buildingGlobalID);
      final features = data['features'] ?? [];
      final props = features.isNotEmpty ? features[0]['properties'] : {};
      emit(Attributes(
          schema, props, ShapeType.polygon, buildingGlobalID, null, null));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  String? get currentBuildingGlobalId =>
      state is Attributes ? (state as Attributes).buildingGlobalId : null;

  String? get currentEntranceGlobalId =>
      state is Attributes ? (state as Attributes).entranceGlobalId : null;

  int? get currentDwellingObjectId =>
      state is Attributes ? (state as Attributes).dwellingObjectId : null;

  ShapeType get shapeType =>
      state is Attributes ? (state as Attributes).shapeType : ShapeType.point;
      
  void clearSelections() {
    emit(AttributesVisibility(false));
  }
}
