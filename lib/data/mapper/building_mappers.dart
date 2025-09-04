// lib/data/mappers/building_mappers.dart
import 'dart:convert';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

/// Convert BuildingDto → Drift companion for insertion
// extension BuildingDtoToDrift on BuildingDto {
//   BuildingsCompanion toCompanion() {
//     // Convert coordinates to raw List<List<List<double>>> for JSON storage
//     final rawCoords = coordinates
//         .map((ring) => ring.map((p) => [p.longitude, p.latitude]).toList())
//         .toList();

//     return BuildingsCompanion(
//       objectId: Value(objectId),
//       geometryType: Value(geometryType),
//       coordinates: Value(jsonEncode(rawCoords)),
//       shapeLength: Value(shapeLength),
//       shapeArea: Value(shapeArea),
//       globalId: Value.absentIfNull(globalId),
//       bldCensus2023: Value.absentIfNull(bldCensus2023),
//       bldQuality: Value.absentIfNull(bldQuality),
//       bldMunicipality: Value.absentIfNull(bldMunicipality),
//       bldEnumArea: Value(bldEnumArea),
//       bldLatitude: Value.absentIfNull(bldLatitude),
//       bldLongitude: Value.absentIfNull(bldLongitude),
//       bldCadastralZone: Value.absentIfNull(bldCadastralZone),
//       bldProperty: Value(bldProperty),
//       bldPermitNumber: Value(bldPermitNumber),
//       bldPermitDate: Value(bldPermitDate),
//       bldStatus: Value.absentIfNull(bldStatus),
//       bldYearConstruction: Value(bldYearConstruction),
//       bldYearDemolition: Value(bldYearDemolition),
//       bldType: Value(bldType),
//       bldClass: Value(bldClass),
//       bldArea: Value(bldArea),
//       bldFloorsAbove: Value(bldFloorsAbove),
//       bldHeight: Value.absentIfNull(bldHeight),
//       bldVolume: Value(bldVolume),
//       bldWasteWater: Value(bldWasteWater),
//       bldElectricity: Value(bldElectricity),
//       bldPipedGas: Value(bldPipedGas),
//       bldElevator: Value(bldElevator),
//       createdDate: Value(createdDate),
//       bldCentroidStatus: Value.absentIfNull(bldCentroidStatus),
//       bldDwellingRecs: Value(bldDwellingRecs),
//       bldEntranceRecs: Value(bldEntranceRecs),
//       bldAddressID: Value.absentIfNull(bldAddressID),
//       bldReview: Value.absentIfNull(bldReview),
//       bldWaterSupply: Value(bldWaterSupply),
//     );
//   }
// }

/// Convert BuildingEntity → Drift row
extension BuildingEntityToDrift on BuildingEntity {
  BuildingsCompanion toDriftBuilding(
      {int downloadId = 0, int recordStatus = RecordStatus.added}) {
    final rawCoords = coordinates
        .map((ring) => ring.map((p) => [p.longitude, p.latitude]).toList())
        .toList();

    return BuildingsCompanion(
      id: Value.absent(),
      downloadId: Value(downloadId),
      recordStatus: Value(recordStatus),
      objectId: Value.absentIfNull(objectId),
      geometryType: Value.absentIfNull(geometryType),
      coordinates: Value(jsonEncode(rawCoords)),
      shapeLength: Value.absentIfNull(shapeLength),
      shapeArea: Value.absentIfNull(shapeArea),
      globalId: Value(globalId ?? uuid.v4()),
      bldCensus2023: Value.absentIfNull(bldCensus2023),
      bldQuality: Value.absentIfNull(bldQuality),
      bldMunicipality: Value.absentIfNull(bldMunicipality),
      bldEnumArea: Value.absentIfNull(bldEnumArea),
      bldLatitude: Value.absentIfNull(bldLatitude),
      bldLongitude: Value.absentIfNull(bldLongitude),
      bldCadastralZone: Value.absentIfNull(bldCadastralZone),
      bldProperty: Value.absentIfNull(bldProperty),
      bldPermitNumber: Value.absentIfNull(bldPermitNumber),
      bldPermitDate: Value.absentIfNull(bldPermitDate),
      bldStatus: Value.absentIfNull(bldStatus),
      bldYearConstruction: Value.absentIfNull(bldYearConstruction),
      bldYearDemolition: Value.absentIfNull(bldYearDemolition),
      bldType: Value.absentIfNull(bldType),
      bldClass: Value.absentIfNull(bldClass),
      bldArea: Value.absentIfNull(bldArea),
      bldFloorsAbove: Value.absentIfNull(bldFloorsAbove),
      bldHeight: Value.absentIfNull(bldHeight),
      bldVolume: Value.absentIfNull(bldVolume),
      bldWasteWater: Value.absentIfNull(bldWasteWater),
      bldElectricity: Value.absentIfNull(bldElectricity),
      bldPipedGas: Value.absentIfNull(bldPipedGas),
      bldElevator: Value.absentIfNull(bldElevator),
      createdUser: Value.absentIfNull(createdUser),
      createdDate: Value.absentIfNull(createdDate),
      lastEditedUser: Value.absentIfNull(lastEditedUser),
      lastEditedDate: Value.absentIfNull(lastEditedDate),
      bldCentroidStatus: Value.absentIfNull(bldCentroidStatus),
      bldDwellingRecs: Value.absentIfNull(bldDwellingRecs),
      bldEntranceRecs: Value.absentIfNull(bldEntranceRecs),
      bldAddressID: Value.absentIfNull(bldAddressID),
      externalCreator: Value.absentIfNull(externalCreator),
      externalEditor: Value.absentIfNull(externalEditor),
      bldReview: Value.absentIfNull(bldReview),
      bldWaterSupply: Value.absentIfNull(bldWaterSupply),
      externalCreatorDate: Value.absentIfNull(externalCreatorDate),
      externalEditorDate: Value.absentIfNull(externalEditorDate),
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
