// lib/data/mappers/building_mappers.dart
import 'dart:convert';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

// DTO -> BuildingsCompanion
extension BuildingDtoToDrift on BuildingDto {
  BuildingsCompanion toCompanion() {
    return BuildingsCompanion(
      objectId: Value(objectId),
      geometryType: Value(geometryType),
      coordinates: Value(jsonEncode(coordinates)),
      shapeLength: Value(shapeLength),
      shapeArea: Value(shapeArea),
      globalId: Value.absentIfNull(globalId),
      bldCensus2023: Value.absentIfNull(bldCensus2023),
      bldQuality: Value.absentIfNull(bldQuality),
      bldMunicipality: Value.absentIfNull(bldMunicipality),
      bldEnumArea: Value(bldEnumArea),
      bldLatitude: Value.absentIfNull(bldLatitude),
      bldLongitude: Value.absentIfNull(bldLongitude),
      bldCadastralZone: Value.absentIfNull(bldCadastralZone),
      bldProperty: Value(bldProperty),
      bldPermitNumber: Value(bldPermitNumber),
      bldPermitDate: Value(bldPermitDate),
      bldStatus: Value.absentIfNull(bldStatus),
      bldYearConstruction: Value(bldYearConstruction),
      bldYearDemolition: Value(bldYearDemolition),
      bldType: Value(bldType),
      bldClass: Value(bldClass),
      bldArea: Value(bldArea),
      bldFloorsAbove: Value(bldFloorsAbove),
      bldHeight: Value.absentIfNull(bldHeight),
      bldVolume: Value(bldVolume),
      bldWasteWater: Value(bldWasteWater),
      bldElectricity: Value(bldElectricity),
      bldPipedGas: Value(bldPipedGas),
      bldElevator: Value(bldElevator),
      // createdUser: Value(createdUser),
      createdDate: Value(createdDate),
      // lastEditedUser: Value(lastEditedUser),
      // lastEditedDate: Value(lastEditedDate),
      bldCentroidStatus: Value.absentIfNull(bldCentroidStatus),
      bldDwellingRecs: Value(bldDwellingRecs),
      bldEntranceRecs: Value(bldEntranceRecs),
      bldAddressID: Value.absentIfNull(bldAddressID),
      // externalCreator: Value(externalCreator),
      // externalEditor: Value(externalEditor),
      bldReview: Value.absentIfNull(bldReview),
      bldWaterSupply: Value(bldWaterSupply),
      // externalCreatorDate: Value(externalCreatorDate),
      // externalEditorDate: Value(externalEditorDate),
    );
  }
}

var uuid = Uuid();

extension BuildingEntityToDrift on BuildingEntity {
  Building toDriftBuilding(int downloadId) {
    return Building(
      objectId: objectId,
      geometryType: geometryType,
      coordinates: jsonEncode(coordinates),
      shapeLength: shapeLength,
      shapeArea: shapeArea,
      globalId: globalId ?? uuid.v4(),
      bldCensus2023: bldCensus2023,
      bldQuality: bldQuality,
      bldMunicipality: bldMunicipality,
      bldEnumArea: bldEnumArea,
      bldLatitude: bldLatitude,
      bldLongitude: bldLongitude,
      bldCadastralZone: bldCadastralZone,
      bldProperty: bldProperty,
      bldPermitNumber: bldPermitNumber,
      bldPermitDate: bldPermitDate,
      bldStatus: bldStatus,
      bldYearConstruction: bldYearConstruction,
      bldYearDemolition: bldYearDemolition,
      bldType: bldType,
      bldClass: bldClass,
      bldArea: bldArea,
      bldFloorsAbove: bldFloorsAbove,
      bldHeight: bldHeight,
      bldVolume: bldVolume,
      bldWasteWater: bldWasteWater,
      bldElectricity: bldElectricity,
      bldPipedGas: bldPipedGas,
      bldElevator: bldElevator,
      // createdUser: Value(createdUser),
      createdDate: createdDate,
      // lastEditedUser: Value(lastEditedUser),
      // lastEditedDate: Value(lastEditedDate),
      bldCentroidStatus: bldCentroidStatus,
      bldDwellingRecs: bldDwellingRecs,
      bldEntranceRecs: bldEntranceRecs,
      bldAddressID: bldAddressID,
      // externalCreator: Value(externalCreator),
      // externalEditor: Value(externalEditor),
      bldReview: bldReview,
      bldWaterSupply: bldWaterSupply,
      downloadId: downloadId,
      id: 0,
      // externalCreatorDate: Value(externalCreatorDate),
      // externalEditorDate: Value(externalEditorDate),
    );
  }
}

// Extension for List<BuildingEntity> to convert to List<Building>
extension BuildingEntityListToDrift on List<BuildingEntity> {
  List<Building> toDriftBuildingList(int downloadId) {
    return map((entity) => entity.toDriftBuilding(downloadId)).toList();
  }
}

// Extension for List<Building> to convert to List<BuildingEntity>
extension BuildingListToEntity on List<Building> {
  List<BuildingEntity> toEntityList() {
    return map((building) => building.toEntity()).toList();
  }
}

// Drift row -> Domain entity
extension BuildingRowToEntity on Building {
  BuildingEntity toEntity() {
    final coordsDecoded =
        (jsonDecode(coordinates) as List).map<List<LatLng>>((r) => r).toList();

    return BuildingEntity(
      objectId: objectId,
      geometryType: geometryType,
      coordinates: coordsDecoded,
      shapeLength: shapeLength,
      shapeArea: shapeArea,
      globalId: globalId,
      bldCensus2023: bldCensus2023,
      bldQuality: bldQuality,
      bldMunicipality: bldMunicipality,
      bldEnumArea: bldEnumArea,
      bldLatitude: bldLatitude,
      bldLongitude: bldLongitude,
      bldCadastralZone: bldCadastralZone,
      bldProperty: bldProperty,
      bldPermitNumber: bldPermitNumber,
      bldPermitDate: bldPermitDate,
      bldStatus: bldStatus,
      bldYearConstruction: bldYearConstruction,
      bldYearDemolition: bldYearDemolition,
      bldType: bldType,
      bldClass: bldClass,
      bldArea: bldArea,
      bldFloorsAbove: bldFloorsAbove,
      bldHeight: bldHeight,
      bldVolume: bldVolume,
      bldWasteWater: bldWasteWater,
      bldElectricity: bldElectricity,
      bldPipedGas: bldPipedGas,
      bldElevator: bldElevator,
      createdDate: createdDate,
      bldCentroidStatus: bldCentroidStatus,
      bldDwellingRecs: bldDwellingRecs,
      bldEntranceRecs: bldEntranceRecs,
      bldAddressID: bldAddressID,
      bldReview: bldReview,
      bldWaterSupply: bldWaterSupply,
    );
  }
}
