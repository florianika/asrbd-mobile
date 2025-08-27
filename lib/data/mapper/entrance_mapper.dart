import 'dart:convert';
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
  Entrance toDriftEntrance(int downloadId) {
    return Entrance(
      globalId: globalId ?? uuid.v4(),
      entBldGlobalId:
          entBldGlobalID ?? '{00000000-0000-0000-0000-000000000000}',
      entAddressId: entAddressID,
      entQuality: entQuality ?? 9,
      entLatitude: entLatitude!,
      entLongitude: entLongitude!,
      entPointStatus: entPointStatus ?? 1,
      entStrGlobalId: entStrGlobalID,
      entBuildingNumber: entBuildingNumber,
      entEntranceNumber: entEntranceNumber,
      entTown: entTown,
      entZipCode: entZipCode,
      entDwellingRecs: entDwellingRecs,
      entDwellingExpec: entDwellingExpec,
      geometryType: geometryType,
      coordinates: coordinates != null
          ? jsonEncode([coordinates!.longitude, coordinates!.latitude])
          : jsonEncode(null),
      downloadId: downloadId,
      id: 0,
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
  List<Entrance> toDriftEntranceList(int downloadId) {
    return map((entity) => entity.toDriftEntrance(downloadId)).toList();
  }
}
