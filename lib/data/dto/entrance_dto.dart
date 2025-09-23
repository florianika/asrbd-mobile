import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:latlong2/latlong.dart';

class EntranceDto {
  final int objectId;
  final String? geometryType;
  final LatLng? coordinates;

  final String? globalId;
  final String? entCensus2023;
  final DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;
  final String? entBldGlobalID;
  final String? entAddressID;
  final int? entQuality;
  final double? entLatitude;
  final double? entLongitude;
  final int? entPointStatus;
  final String? entStrGlobalID;
  final String? entBuildingNumber;
  final String? entEntranceNumber;
  final int? entTown;
  final int? entZipCode;
  final int? entDwellingRecs;
  final int? entDwellingExpec;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  final String? externalCreator;
  final String? externalEditor;

  EntranceDto({
    required this.objectId,
    this.geometryType = 'Point',
    this.coordinates,
    this.globalId,
    this.entCensus2023 = '9999999999999',
    this.externalCreatorDate,
    this.externalEditorDate,
    this.entBldGlobalID = '{00000000-0000-0000-0000-000000000000}',
    this.entAddressID,
    this.entQuality = 9,
    this.entLatitude,
    this.entLongitude,
    this.entPointStatus = 1,
    this.entStrGlobalID,
    this.entBuildingNumber,
    this.entEntranceNumber,
    this.entTown,
    this.entZipCode,
    this.entDwellingRecs,
    this.entDwellingExpec,
    this.createdUser,
    this.createdDate,
    this.lastEditedUser,
    this.lastEditedDate,
    this.externalCreator,
    this.externalEditor,
  });

  static DateTime? _fromEpochMs(dynamic v) {
    if (v == null) return null;
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    if (v is String) {
      final parsed = int.tryParse(v);
      if (parsed != null) return DateTime.fromMillisecondsSinceEpoch(parsed);
    }
    return null;
  }

  factory EntranceDto.fromMap(Map<String, dynamic> map) {
    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;
    double? safeDouble(dynamic v) => (v is num) ? v.toDouble() : null;

    LatLng? parseCoordinates(dynamic coordsData) {
      if (coordsData is List && coordsData.length >= 2) {
        final lon = (coordsData[0] as num).toDouble();
        final lat = (coordsData[1] as num).toDouble();
        return LatLng(lat, lon);
      } else if (coordsData is Map &&
          coordsData.containsKey('latitude') &&
          coordsData.containsKey('longitude')) {
        final lat = (coordsData['latitude'] as num).toDouble();
        final lon = (coordsData['longitude'] as num).toDouble();
        return LatLng(lat, lon);
      }
      return null;
    }

    return EntranceDto(
      objectId: safeInt(map['OBJECTID']) ?? 0,
      geometryType: map['GeometryType'] as String?,
      coordinates: parseCoordinates(map['Coordinates']),
      globalId: map['GlobalID'] as String?,
      entCensus2023: map['EntCensus2023'] as String?,
      externalCreatorDate: _fromEpochMs(map['external_creator_date']) ??
          (map['external_creator_date'] is String
              ? DateTime.tryParse(map['external_creator_date'])
              : null),
      externalEditorDate: _fromEpochMs(map['external_editor_date']) ??
          (map['external_editor_date'] is String
              ? DateTime.tryParse(map['external_editor_date'])
              : null),
      entBldGlobalID: map['EntBldGlobalID'] as String?,
      entAddressID: map['EntAddressID'] as String?,
      entQuality: safeInt(map['EntQuality']),
      entLatitude: safeDouble(map['EntLatitude']),
      entLongitude: safeDouble(map['EntLongitude']),
      entPointStatus: safeInt(map['EntPointStatus']),
      entStrGlobalID: map['EntStrGlobalID'] as String?,
      entBuildingNumber: map['EntBuildingNumber'] as String?,
      entEntranceNumber: map['EntEntranceNumber'] as String?,
      entTown: safeInt(map['EntTown']),
      entZipCode: safeInt(map['EntZipCode']),
      entDwellingRecs: safeInt(map['EntDwellingRecs']),
      entDwellingExpec: safeInt(map['EntDwellingExpec']),
      createdUser: map['created_user'] as String?,
      createdDate: _fromEpochMs(map['created_date']) ??
          (map['created_date'] is String
              ? DateTime.tryParse(map['created_date'])
              : null),
      lastEditedUser: map['last_edited_user'] as String?,
      lastEditedDate: _fromEpochMs(map['last_edited_date']) ??
          (map['last_edited_date'] is String
              ? DateTime.tryParse(map['last_edited_date'])
              : null),
      externalCreator: map['external_creator'] as String?,
      externalEditor: map['external_editor'] as String?,
    );
  }

  Map<String, dynamic> toGeoJsonFeature() {
    final attributes = <String, dynamic>{
      "OBJECTID": objectId,
      "GlobalID": globalId,
      "EntCensus2023": entCensus2023,
      "external_creator_date": externalCreatorDate?.millisecondsSinceEpoch,
      "external_editor_date": externalEditorDate?.millisecondsSinceEpoch,
      "EntBldGlobalID": entBldGlobalID,
      "EntAddressID": entAddressID,
      "EntQuality": entQuality,
      "EntLatitude": entLatitude,
      "EntLongitude": entLongitude,
      "EntPointStatus": entPointStatus,
      "EntStrGlobalID": entStrGlobalID,
      "EntBuildingNumber": entBuildingNumber,
      "EntEntranceNumber": entEntranceNumber,
      "EntTown": entTown,
      "EntZipCode": entZipCode,
      "EntDwellingRecs": entDwellingRecs,
      "EntDwellingExpec": entDwellingExpec,
      "created_user": createdUser,
      "created_date": createdDate?.millisecondsSinceEpoch,
      "last_edited_user": lastEditedUser,
      "last_edited_date": lastEditedDate?.millisecondsSinceEpoch,
      "external_creator": externalCreator,
      "external_editor": externalEditor,
    };

    return {
      "type": "Feature",
      "geometry": {
        "x": coordinates!.longitude,
        "y": coordinates!.latitude,
        'spatialReference': {'wkid': 4326},
      },
      "attributes": attributes
    };
  }

  factory EntranceDto.fromGeoJsonFeature(Map<String, dynamic> feature) {
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final type = geometry['type'] as String?;
    final coordsRaw = geometry['coordinates'];

    LatLng? coords;

    if (type == 'Point' && coordsRaw is List && coordsRaw.length >= 2) {
      final lon = (coordsRaw[0] as num).toDouble();
      final lat = (coordsRaw[1] as num).toDouble();
      coords = LatLng(lat, lon);
    }

    final props = feature['properties'] as Map<String, dynamic>? ?? {};

    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;
    double? safeDouble(dynamic v) => (v is num) ? v.toDouble() : null;

    return EntranceDto(
      objectId: safeInt(props['OBJECTID']) ?? 0,
      geometryType: type,
      coordinates: coords,
      globalId: props['GlobalID'] as String?,
      entCensus2023: props['EntCensus2023'] as String?,
      externalCreatorDate: _fromEpochMs(props['external_creator_date']),
      externalEditorDate: _fromEpochMs(props['external_editor_date']),
      entBldGlobalID: props['EntBldGlobalID'] as String?,
      entAddressID: props['EntAddressID'] as String?,
      entQuality: safeInt(props['EntQuality']),
      entLatitude: safeDouble(props['EntLatitude']),
      entLongitude: safeDouble(props['EntLongitude']),
      entPointStatus: safeInt(props['EntPointStatus']),
      entStrGlobalID: props['EntStrGlobalID'] as String?,
      entBuildingNumber: props['EntBuildingNumber'] as String?,
      entEntranceNumber: props['EntEntranceNumber'] as String?,
      entTown: safeInt(props['EntTown']),
      entZipCode: safeInt(props['EntZipCode']),
      entDwellingRecs: safeInt(props['EntDwellingRecs']),
      entDwellingExpec: safeInt(props['EntDwellingExpec']),
      createdUser: props['created_user'] as String?,
      createdDate: _fromEpochMs(props['created_date']),
      lastEditedUser: props['last_edited_user'] as String?,
      lastEditedDate: _fromEpochMs(props['last_edited_date']),
      externalCreator: props['external_creator'] as String?,
      externalEditor: props['external_editor'] as String?,
    );
  }

  EntranceEntity toEntity() {
    return EntranceEntity(
      objectId: objectId,
      geometryType: geometryType,
      coordinates: coordinates,
      globalId: globalId,
      entCensus2023: entCensus2023,
      externalCreatorDate: externalCreatorDate,
      externalEditorDate: externalEditorDate,
      entBldGlobalID: entBldGlobalID,
      entAddressID: entAddressID,
      entQuality: entQuality ?? DefaultData.entQualityUntested,
      entLatitude: entLatitude,
      entLongitude: entLongitude,
      entPointStatus: entPointStatus ?? DefaultData.entPointStatus,
      entStrGlobalID: entStrGlobalID,
      entBuildingNumber: entBuildingNumber,
      entEntranceNumber: entEntranceNumber,
      entTown: entTown,
      entZipCode: entZipCode,
      entDwellingRecs: entDwellingRecs,
      entDwellingExpec: entDwellingExpec,
      createdUser: createdUser,
      createdDate: createdDate,
      lastEditedUser: lastEditedUser,
      lastEditedDate: lastEditedDate,
      externalCreator: externalCreator,
      externalEditor: externalEditor,
    );
  }

  factory EntranceDto.fromEntity(EntranceEntity entity) {
    return EntranceDto(
      objectId: entity.objectId,
      geometryType: entity.geometryType,
      coordinates: entity.coordinates,
      globalId: entity.globalId,
      entCensus2023: entity.entCensus2023,
      externalCreatorDate: entity.externalCreatorDate,
      externalEditorDate: entity.externalEditorDate,
      entBldGlobalID: entity.entBldGlobalID,
      entAddressID: entity.entAddressID,
      entQuality: entity.entQuality,
      entLatitude: entity.entLatitude,
      entLongitude: entity.entLongitude,
      entPointStatus: entity.entPointStatus,
      entStrGlobalID: entity.entStrGlobalID,
      entBuildingNumber: entity.entBuildingNumber,
      entEntranceNumber: entity.entEntranceNumber,
      entTown: entity.entTown,
      entZipCode: entity.entZipCode,
      entDwellingRecs: entity.entDwellingRecs,
      entDwellingExpec: entity.entDwellingExpec,
      createdUser: entity.createdUser,
      createdDate: entity.createdDate,
      lastEditedUser: entity.lastEditedUser,
      lastEditedDate: entity.lastEditedDate,
      externalCreator: entity.externalCreator,
      externalEditor: entity.externalEditor,
    );
  }
}
