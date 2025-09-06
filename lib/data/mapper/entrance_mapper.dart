import 'dart:convert';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/dto/entrance_dto.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

// DTO -> EntrancesCompanion
extension EntranceDtoToDrift on EntranceDto {
  EntrancesCompanion toCompanion() {
    return EntrancesCompanion(
      globalId: Value(globalId ?? const Uuid().v4()),
      entBldGlobalId:
          Value(entBldGlobalID ?? '{00000000-0000-0000-0000-000000000000}'),
      entAddressId: Value.absentIfNull(entAddressID),
      entQuality: Value.absentIfNull(entQuality),
      entLatitude: Value.absentIfNull(entLatitude),
      entLongitude: Value.absentIfNull(entLongitude),
      entPointStatus: Value.absentIfNull(entPointStatus),
      entStrGlobalId: Value.absentIfNull(entStrGlobalID),
      entBuildingNumber: Value.absentIfNull(entBuildingNumber),
      entEntranceNumber: Value.absentIfNull(entEntranceNumber),
      entTown: Value.absentIfNull(entTown),
      entZipCode: Value.absentIfNull(entZipCode),
      entDwellingRecs: Value.absentIfNull(entDwellingRecs),
      entDwellingExpec: Value.absentIfNull(entDwellingExpec),
      geometryType: Value(geometryType),
      coordinates: Value(coordinates != null
          ? jsonEncode([coordinates!.longitude, coordinates!.latitude])
          : jsonEncode(null)),
    );
  }
}

var uuid = const Uuid();

extension EntranceEntityToDrift on EntranceEntity {
  EntrancesCompanion toDriftEntrance(
      {int downloadId = 0, int recordStatus = RecordStatus.unmodified}) {
    return EntrancesCompanion(
      recordStatus: Value(recordStatus),
      globalId: Value(globalId ?? uuid.v4()),
      entBldGlobalId: entBldGlobalID != null
          ? Value(entBldGlobalID!)
          : Value('{00000000-0000-0000-0000-000000000000}'),
      entAddressId: Value(entAddressID),
      entQuality: entQuality != null ? Value(entQuality!) : Value(9),
      entLatitude: entLatitude != null ? Value(entLatitude!) : Value(0),
      entLongitude: entLongitude != null ? Value(entLongitude!) : Value(0),
      entPointStatus:
          entPointStatus != null ? Value(entPointStatus!) : Value(1),
      entStrGlobalId: Value.absentIfNull(entStrGlobalID),
      entBuildingNumber: Value.absentIfNull(entBuildingNumber),
      entEntranceNumber: Value.absentIfNull(entEntranceNumber),
      entTown: Value.absentIfNull(entTown),
      entZipCode: Value.absentIfNull(entZipCode),
      entDwellingRecs: Value.absentIfNull(entDwellingRecs),
      entDwellingExpec: Value.absentIfNull(entDwellingExpec),
      geometryType: Value.absentIfNull(geometryType),
      coordinates:
          Value(jsonEncode([coordinates!.longitude, coordinates!.latitude])),
      downloadId: Value(downloadId),
    );
  }
}

// Drift row -> Domain entity
extension EntranceRowToEntity on Entrance {
  EntranceEntity toEntity() {
    LatLng? coordsDecoded;

    try {
      final decoded = jsonDecode(coordinates);
      if (decoded is List && decoded.length >= 2) {
        coordsDecoded = LatLng(
          (decoded[1] as num).toDouble(), // latitude
          (decoded[0] as num).toDouble(), // longitude
        );
      }
    } catch (e) {
      // Handle decode error - coordinates will remain null
      coordsDecoded = null;
    }

    return EntranceEntity(
      objectId: id,
      recordStatus: recordStatus,
      geometryType: geometryType,
      coordinates: coordsDecoded,
      globalId: globalId,
      entBldGlobalID: entBldGlobalId,
      entAddressID: entAddressId,
      entQuality: entQuality,
      entLatitude: entLatitude,
      entLongitude: entLongitude,
      entPointStatus: entPointStatus,
      entStrGlobalID: entStrGlobalId,
      entBuildingNumber: entBuildingNumber,
      entEntranceNumber: entEntranceNumber,
      entTown: entTown,
      entZipCode: entZipCode,
      entDwellingRecs: entDwellingRecs,
      entDwellingExpec: entDwellingExpec,
    );
  }
}

extension EntranceEntityListToDrift on List<EntranceEntity> {
  List<EntrancesCompanion> toDriftEntranceList(int downloadId) =>
      map((e) => e.toDriftEntrance(downloadId: downloadId)).toList();
}

extension EntranceListToEntity on List<Entrance> {
  List<EntranceEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
