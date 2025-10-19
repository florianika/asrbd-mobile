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
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:get_it/get_it.dart';

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
  final bool isNewlyCreated;

  Attributes(
    this.schema,
    this.initialData,
    this.shapeType,
    this.buildingGlobalId,
    this.entranceGlobalId,
    this.dwellingObjectId, {
    this.viewDwelling = false,
    this.showAttributes = false,
    this.isNewlyCreated = false,
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
        isNewlyCreated,
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

  // Permanent storage fields - these persist regardless of state
  EntranceEntity? _persistentEntrance;
  BuildingEntity? _persistentBuilding;
  DwellingEntity? _persistentDwelling;

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

  Future<void> showDwellingAttributes(
      int? dwellingObjectID, bool isOffline, int? downloadId) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await dwellingUseCases.getDwellingAttibutes();
      if (dwellingObjectID == null) {
        // Clear persistent dwelling when showing attributes for new dwelling
        _persistentDwelling = null;

        emit(Attributes(
          schema,
          const {},
          ShapeType.noShape,
          null,
          null,
          null,
          viewDwelling: false,
          showAttributes: true,
          isNewlyCreated: true,
        ));
        return;
      }

      final dwelling = await dwellingUseCases.getDwellingDetails(
        dwellingObjectID,
        isOffline,
        downloadId,
      );

      // Store permanently
      _persistentDwelling = dwelling;

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
    String? entranceGlobalID,
    String? buildingGlobalID,
    bool isOffline,
    int? downloadId, {
    bool isNewlyCreated = false,
  }) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await entranceUseCases.getEntranceAttributes();
      if (entranceGlobalID == null) {
        // Clear persistent entrance when showing attributes for new entrance
        _persistentEntrance = null;

        emit(Attributes(
          schema,
          {EntranceFields.entBldGlobalID: buildingGlobalID},
          ShapeType.point,
          buildingGlobalID,
          entranceGlobalID,
          null,
          showAttributes: true,
          isNewlyCreated: true,
        ));
        return;
      }

      final entrance = await entranceUseCases.getEntranceDetails(
        entranceGlobalID,
        isOffline,
        downloadId,
      );

      // Store permanently
      _persistentEntrance = entrance;

      emit(Attributes(
        schema,
        entrance.toMap(),
        ShapeType.point,
        entrance.globalId,
        entranceGlobalID,
        null,
        showAttributes: true,
        isNewlyCreated: isNewlyCreated,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> showBuildingAttributes(
    String? buildingGlobalID,
    bool isOffline,
    int? downloadId, {
    bool isNewlyCreated = false,
  }) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await buildingUseCases.getBuildingAttibutes();
      if (buildingGlobalID == null) {
        // Clear persistent building when showing attributes for new building
        _persistentBuilding = null;

        emit(Attributes(
          schema,
          const {},
          ShapeType.polygon,
          null,
          null,
          null,
          showAttributes: true,
          isNewlyCreated: true,
        ));
        return;
      }

      final building = await buildingUseCases.getBuildingDetails(
        buildingGlobalID,
        isOffline,
        downloadId,
      );

      // Store permanently
      _persistentBuilding = building;

      emit(Attributes(
        schema,
        building.toMap(),
        ShapeType.polygon,
        buildingGlobalID,
        null,
        null,
        showAttributes: true,
        isNewlyCreated: isNewlyCreated,
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
        isNewlyCreated: true,
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

      // Create a new EntranceEntity with defaults
      final newEntrance = EntranceEntity(
          objectId: 0,
          coordinates: coordinates,
          entBldGlobalID: buildingGlobalId);

      emit(Attributes(
        schema,
        newEntrance.toMap(),
        ShapeType.point,
        null,
        null,
        null,
        showAttributes: true,
        isNewlyCreated: true,
      ));
    } catch (e) {
      emit(AttributesError(e.toString()));
    }
  }

  Future<void> updateEntrance(LatLng coordinates) async {
    if (showLoading) emit(AttributesLoading());
    try {
      final schema = await entranceUseCases.getEntranceAttributes();

      final updatedEntrance =
          EntranceEntity.fromMap((state as Attributes).initialData);
      updatedEntrance.coordinates = coordinates;

      emit(Attributes(
        schema,
        updatedEntrance.toMap(),
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

  // Modified getters - now return persistent entities regardless of state
  BuildingEntity? get currentBuilding => _persistentBuilding;
  EntranceEntity? get currentEntrance => _persistentEntrance;
  DwellingEntity? get currentDwelling => _persistentDwelling;

  // Convenience getters for IDs (if still needed)
  String? get currentBuildingGlobalId => _persistentBuilding?.globalId;
  String? get currentEntranceGlobalId => _persistentEntrance?.globalId;
  int? get currentDwellingObjectId => _persistentDwelling?.objectId;

  ShapeType get shapeType =>
      state is Attributes ? (state as Attributes).shapeType : ShapeType.point;

  bool get isShowingAttributes =>
      state is Attributes ? (state as Attributes).showAttributes : false;

  void clearSelections() {
    toggleAttributesVisibility(false);
  }

   void clearAllSelections() {
    _persistentEntrance = null;
    _persistentBuilding = null;
    _persistentDwelling = null;
    
    toggleAttributesVisibility(false);
    
    try {
      final storageRepository = GetIt.instance<StorageRepository>();
      storageRepository.remove(
        boxName: HiveBoxes.selectedBuilding,
        key: 'currentBuildingGlobalId',
      );
    } catch (e) {
      // Ignore storage errors
    }
  }

  // Optional: method to clear persistent values
  void clearPersistentSelections() {
    _persistentEntrance = null;
    _persistentBuilding = null;
    _persistentDwelling = null;
    toggleAttributesVisibility(false);
  }

  // Optional: methods to manually set persistent values
  void setPersistentEntrance(EntranceEntity? entrance) {
    _persistentEntrance = entrance;
  }

  void setPersistentBuilding(BuildingEntity? building) {
    _persistentBuilding = building;
  }

  void setPersistentDwelling(DwellingEntity? dwelling) {
    _persistentDwelling = dwelling;
  }
}
