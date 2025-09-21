// lib/data/mappers/building_mappers.dart
import 'dart:convert';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

/// Convert BuildingEntity → Drift row
extension BuildingEntityToDrift on BuildingEntity {
  BuildingsCompanion toDriftBuilding(
      {int downloadId = 0, int recordStatus = RecordStatus.unmodified}) {
    final rawCoords = coordinates
        .map((ring) => ring.map((p) => [p.longitude, p.latitude]).toList())
        .toList();

    return BuildingsCompanion(
      id: Value.absent(),
      downloadId: Value(downloadId),
      recordStatus: Value(recordStatus),
      objectId: Value(objectId),
      geometryType: Value(geometryType),
      coordinates: Value(jsonEncode(rawCoords)),
      shapeLength: Value(shapeLength),
      shapeArea: Value(shapeArea),
      globalId: Value(globalId ?? uuid.v4()),
      bldCensus2023: Value(bldCensus2023),
      bldQuality: Value(bldQuality),
      bldMunicipality: Value(bldMunicipality),
      bldEnumArea: Value(bldEnumArea),
      bldLatitude: Value(bldLatitude),
      bldLongitude: Value(bldLongitude),
      bldCadastralZone: Value(bldCadastralZone),
      bldProperty: Value(bldProperty),
      bldPermitNumber: Value(bldPermitNumber),
      bldPermitDate: Value(bldPermitDate),
      bldStatus: Value(bldStatus),
      bldYearConstruction: Value(bldYearConstruction),
      bldYearDemolition: Value(bldYearDemolition),
      bldType: Value(bldType),
      bldClass: Value(bldClass),
      bldArea: Value(bldArea),
      bldFloorsAbove: Value(bldFloorsAbove),
      bldHeight: Value(bldHeight),
      bldVolume: Value(bldVolume),
      bldWasteWater: Value(bldWasteWater),
      bldElectricity: Value(bldElectricity),
      bldPipedGas: Value(bldPipedGas),
      bldElevator: Value(bldElevator),
      createdUser: Value(createdUser),
      createdDate: Value(createdDate),
      lastEditedUser: Value(lastEditedUser),
      lastEditedDate: Value(lastEditedDate),
      bldCentroidStatus: Value(bldCentroidStatus),
      bldDwellingRecs: Value(bldDwellingRecs),
      bldEntranceRecs: Value(bldEntranceRecs),
      bldAddressID: Value(bldAddressID),
      externalCreator: Value(externalCreator),
      externalEditor: Value(externalEditor),
      bldReview: Value(bldReview),
      bldWaterSupply: Value(bldWaterSupply),
      externalCreatorDate: Value(externalCreatorDate),
      externalEditorDate: Value(externalEditorDate),
    );
  }
}

/// Convert Drift row → BuildingEntity
extension BuildingRowToEntity on Building {
  BuildingEntity toEntity() {
    final rawCoords = jsonDecode(coordinates) as List<dynamic>? ?? [];

    final coordsDecoded = rawCoords.map<List<LatLng>>((ring) {
      return (ring as List<dynamic>).map<LatLng>((point) {
        final lon = (point[0] as num?)?.toDouble() ?? 0.0;
        final lat = (point[1] as num?)?.toDouble() ?? 0.0;
        return LatLng(lat, lon);
      }).toList();
    }).toList();

    return BuildingEntity(
      objectId: objectId ?? 0,
      geometryType: geometryType,
      coordinates: coordsDecoded,
      recordStatus: recordStatus,
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

extension BuildingEntityListToDrift on List<BuildingEntity> {
  List<BuildingsCompanion> toDriftBuildingList(int downloadId) =>
      map((e) => e.toDriftBuilding(downloadId: downloadId)).toList();
}

extension BuildingListToEntity on List<Building> {
  List<BuildingEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
