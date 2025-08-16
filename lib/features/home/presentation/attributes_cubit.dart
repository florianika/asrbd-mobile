import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/enums/shape_type.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:latlong2/latlong.dart';

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
  final bool showAttributes;
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
    this.showAttributes = false,
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
        showAttributes,
      ];

  Attributes copyWith({
    List<FieldSchema>? schema,
    Map<String, dynamic>? initialData,
    ShapeType? shapeType,
    String? buildingGlobalId,
    String? entranceGlobalId,
    int? dwellingObjectId,
    bool? viewDwelling,
    bool? showAttributes,
  }) {
    return Attributes(
      schema ?? this.schema,
      initialData ?? this.initialData,
      shapeType ?? this.shapeType,
      buildingGlobalId ?? this.buildingGlobalId,
      entranceGlobalId ?? this.entranceGlobalId,
      dwellingObjectId ?? this.dwellingObjectId,
      viewDwelling: viewDwelling ?? this.viewDwelling,
      showAttributes: showAttributes ?? this.showAttributes,
    );
  }
}

class AttributesError extends AttributesState {
  final String message;
  AttributesError(this.message);

  @override
  List<Object?> get props => [message];
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
  ) : super(Attributes(const [], const {}, ShapeType.point, null, null, null));

  void setShowLoading(bool value) {
    showLoading = value;
  }

  void toggleAttributesVisibility(bool showAttributes) {
    final currentState = state;
    if (currentState is Attributes) {
      emit(currentState.copyWith(showAttributes: showAttributes));
    } else {
      emit(Attributes(
        const [],
        const {},
        ShapeType.point,
        null,
        null,
        null,
        showAttributes: showAttributes,
      ));
    }
  }

  void showAttributes(bool show) {
    toggleAttributesVisibility(show);
  }

  Future<void> showDwellingAttributes(int? dwellingObjectID) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await dwellingUseCases.getDwellingAttibutes();
      if (dwellingObjectID == null) {
        emit(Attributes(
          schema,
          const {},
          ShapeType.noShape,
          null,
          null,
          null,
          viewDwelling: true,
          showAttributes: true,
        ));
        return;
      }

      final dwelling = await dwellingUseCases.getDwellingDetails(dwellingObjectID);
      // final features = data[GeneralFields.features] ?? [];
      // final props =
      //     features.isNotEmpty ? features[0][GeneralFields.properties] : {};
      emit(Attributes(
        schema,
        dwelling.toMap(),
        ShapeType.noShape,
        null,
        null,
        dwellingObjectID,
        viewDwelling: true,
        showAttributes: true,
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
        emit(Attributes(
          schema,
          {EntranceFields.entBldGlobalID: buildingGlobalID},
          ShapeType.point,
          buildingGlobalID,
          entranceGlobalID,
          null,
          showAttributes: true,
        ));
        return;
      }

      final entrance =
          await entranceUseCases.getEntranceDetails(entranceGlobalID);

      emit(Attributes(
        schema,
        entrance.toMap(),
        ShapeType.point,
        entrance.globalId,
        entranceGlobalID,
        null,
        showAttributes: true,
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
        emit(Attributes(
          schema,
          const {},
          ShapeType.polygon,
          null,
          null,
          null,
          showAttributes: true,
        ));
        return;
      }

      final building =
          await buildingUseCases.getBuildingDetails(buildingGlobalID);

      emit(Attributes(
        schema,
        building.toMap(),
        ShapeType.polygon,
        buildingGlobalID,
        null,
        null,
        showAttributes: true,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> addNewBuilding(List<LatLng> coordinates) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();

      // Create a new BuildingEntity with defaults
      final newBuilding = BuildingEntity(
        objectId: 0,
        coordinates: [coordinates],
        shapeLength: null,
        shapeArea: null,
        globalId: null,
        bldMunicipality: null,
        bldEnumArea: null,
        bldLatitude: null,
        bldLongitude: null,
        bldCadastralZone: null,
        bldProperty: null,
        bldPermitNumber: null,
        bldPermitDate: null,
        bldYearConstruction: null,
        bldYearDemolition: null,
        bldArea: null,
        bldFloorsAbove: null,
        bldHeight: null,
        bldVolume: null,
        createdUser: null,
        createdDate: null,
        lastEditedUser: null,
        lastEditedDate: null,
        bldDwellingRecs: null,
        bldEntranceRecs: null,
        bldAddressID: null,
        externalCreator: null,
        externalEditor: null,
        externalCreatorDate: null,
        externalEditorDate: null,
      );

      emit(Attributes(
        schema,
        newBuilding.toMap(),
        ShapeType.polygon,
        null,
        null,
        null,
        showAttributes: true,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> addNewEntrance(
      LatLng coordinates, String buildingGlobalId) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await entranceUseCases.getEntranceAttributes();

      // Create a new BuildingEntity with defaults
      final newBuilding = EntranceEntity(
          objectId: 0,
          coordinates: coordinates,
          entBldGlobalID: buildingGlobalId);

      emit(Attributes(
        schema,
        newBuilding.toMap(),
        ShapeType.point,
        null,
        null,
        null,
        showAttributes: true,
      ));
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

  bool get isShowingAttributes =>
      state is Attributes ? (state as Attributes).showAttributes : false;

  void clearSelections() {
    toggleAttributesVisibility(false);
  }
}
