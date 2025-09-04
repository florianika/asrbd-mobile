import 'package:asrdb/core/models/record_status.dart';
import 'package:latlong2/latlong.dart';

class EntranceEntity {
  final int objectId;
  final int? featureId;
  final String? geometryType;
  LatLng? coordinates;

  final String? globalId;
  final int? recordStatus;
  final String? entCensus2023;
  DateTime? externalCreatorDate;
  DateTime? externalEditorDate;
  String? entBldGlobalID;
  final String? entAddressID;
  final int? entQuality;
  double? entLatitude;
  double? entLongitude;
  int? entPointStatus;
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
  String? externalCreator;
  String? externalEditor;

  EntranceEntity({
    this.objectId = 0,
    this.featureId,
    this.geometryType = "Point",
    this.coordinates,
    this.globalId,
    this.recordStatus = RecordStatus.unmodified,
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

  // ✅ copyWith method
  EntranceEntity copyWith({
    int? objectId,
    int? featureId,
    String? geometryType,
    LatLng? coordinates,
    String? globalId,
    String? entCensus2023,
    DateTime? externalCreatorDate,
    DateTime? externalEditorDate,
    String? entBldGlobalID,
    String? entAddressID,
    int? entQuality,
    double? entLatitude,
    double? entLongitude,
    int? entPointStatus,
    String? entStrGlobalID,
    String? entBuildingNumber,
    String? entEntranceNumber,
    int? entTown,
    int? entZipCode,
    int? entDwellingRecs,
    int? entDwellingExpec,
    String? createdUser,
    DateTime? createdDate,
    String? lastEditedUser,
    DateTime? lastEditedDate,
    String? externalCreator,
    String? externalEditor,
  }) {
    return EntranceEntity(
      objectId: objectId ?? this.objectId,
      featureId: featureId ?? this.featureId,
      geometryType: geometryType ?? this.geometryType,
      coordinates: coordinates ?? this.coordinates,
      globalId: globalId ?? this.globalId,
      entCensus2023: entCensus2023 ?? this.entCensus2023,
      externalCreatorDate: externalCreatorDate ?? this.externalCreatorDate,
      externalEditorDate: externalEditorDate ?? this.externalEditorDate,
      entBldGlobalID: entBldGlobalID ?? this.entBldGlobalID,
      entAddressID: entAddressID ?? this.entAddressID,
      entQuality: entQuality ?? this.entQuality,
      entLatitude: entLatitude ?? this.entLatitude,
      entLongitude: entLongitude ?? this.entLongitude,
      entPointStatus: entPointStatus ?? this.entPointStatus,
      entStrGlobalID: entStrGlobalID ?? this.entStrGlobalID,
      entBuildingNumber: entBuildingNumber ?? this.entBuildingNumber,
      entEntranceNumber: entEntranceNumber ?? this.entEntranceNumber,
      entTown: entTown ?? this.entTown,
      entZipCode: entZipCode ?? this.entZipCode,
      entDwellingRecs: entDwellingRecs ?? this.entDwellingRecs,
      entDwellingExpec: entDwellingExpec ?? this.entDwellingExpec,
      createdUser: createdUser ?? this.createdUser,
      createdDate: createdDate ?? this.createdDate,
      lastEditedUser: lastEditedUser ?? this.lastEditedUser,
      lastEditedDate: lastEditedDate ?? this.lastEditedDate,
      externalCreator: externalCreator ?? this.externalCreator,
      externalEditor: externalEditor ?? this.externalEditor,
    );
  }

  static DateTime? _fromEpochMs(dynamic v) {
    if (v == null) return null;
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    if (v is String) {
      final parsed = int.tryParse(v);
      if (parsed != null) return DateTime.fromMillisecondsSinceEpoch(parsed);
    }
    return null;
  }

  factory EntranceEntity.fromMap(Map<String, dynamic> map) {
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

    return EntranceEntity(
      globalId: map['GlobalID'] as String?,
      objectId: safeInt(map['OBJECTID']) ?? 0,
      featureId: safeInt(map['FeatureId']),
      geometryType: map['GeometryType'] as String?,
      coordinates: parseCoordinates(map['Coordinates']),
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
}

extension EntranceEntityMapper on EntranceEntity {
  Map<String, dynamic> toMap() {
    return {
      'GlobalID': globalId,
      'OBJECTID': objectId,
      'FeatureId': featureId,
      'GeometryType': geometryType,
      'Coordinates': coordinates != null
          ? [coordinates!.longitude, coordinates!.latitude]
          : null,
      'EntCensus2023': entCensus2023,
      'external_creator_date': externalCreatorDate?.millisecondsSinceEpoch,
      'external_editor_date': externalEditorDate?.millisecondsSinceEpoch,
      'EntBldGlobalID': entBldGlobalID,
      'EntAddressID': entAddressID,
      'EntQuality': entQuality,
      'EntLatitude': entLatitude,
      'EntLongitude': entLongitude,
      'EntPointStatus': entPointStatus,
      'EntStrGlobalID': entStrGlobalID,
      'EntBuildingNumber': entBuildingNumber,
      'EntEntranceNumber': entEntranceNumber,
      'EntTown': entTown,
      'EntZipCode': entZipCode,
      'EntDwellingRecs': entDwellingRecs,
      'EntDwellingExpec': entDwellingExpec,
      'created_user': createdUser,
      'created_date': createdDate?.millisecondsSinceEpoch,
      'last_edited_user': lastEditedUser,
      'last_edited_date': lastEditedDate?.millisecondsSinceEpoch,
      'external_creator': externalCreator,
      'external_editor': externalEditor,
    };
  }
}
