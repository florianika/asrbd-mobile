import 'package:asrdb/core/models/record_status.dart';

class DwellingEntity {
  final int objectId;
  final int? featureId;
  final String? geometryType;
  final String? globalId;
  final int? recordStatus;
  String? dwlEntGlobalID;
  final String? dwlCensus2023;
  DateTime? externalCreatorDate;
  DateTime? externalEditorDate;
  final String? dwlAddressID;
  final int? dwlQuality;
  final int? dwlFloor;
  final String? dwlApartNumber;
  final int? dwlStatus;
  final int? dwlYearConstruction;
  final int? dwlYearElimination;
  final int? dwlType;
  final int? dwlOwnership;
  final int? dwlOccupancy;
  final int? dwlSurface;
  final int? dwlToilet;
  final int? dwlBath;
  final int? dwlHeatingFacility;
  final int? dwlHeatingEnergy;
  final int? dwlAirConditioner;
  final int? dwlSolarPanel;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  String? externalCreator;
  String? externalEditor;

  DwellingEntity({
    required this.objectId,
    this.featureId,
    this.geometryType,
    this.globalId,
    this.dwlEntGlobalID = '{00000000-0000-0000-0000-000000000000}',
    this.dwlCensus2023 = '99999999999999999',
    this.recordStatus = RecordStatus.unmodified,
    this.externalCreatorDate,
    this.externalEditorDate,
    this.dwlAddressID,
    this.dwlQuality = 9,
    this.dwlFloor,
    this.dwlApartNumber,
    this.dwlStatus = 4,
    this.dwlYearConstruction,
    this.dwlYearElimination,
    this.dwlType = 9,
    this.dwlOwnership = 99,
    this.dwlOccupancy = 99,
    this.dwlSurface,
    this.dwlToilet = 99,
    this.dwlBath = 9,
    this.dwlHeatingFacility = 99,
    this.dwlHeatingEnergy = 99,
    this.dwlAirConditioner = 9,
    this.dwlSolarPanel = 9,
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

  factory DwellingEntity.fromMap(Map<String, dynamic> map) {
    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;

    return DwellingEntity(
      globalId: map['GlobalID'] as String?,
      objectId: safeInt(map['OBJECTID']) ?? 0,
      featureId: safeInt(map['FeatureId']),
      geometryType: map['GeometryType'] as String?,
      dwlEntGlobalID: map['DwlEntGlobalID'] as String?,
      dwlCensus2023: map['DwlCensus2023'] as String?,
      externalCreatorDate: _fromEpochMs(map['external_creator_date']) ??
          (map['external_creator_date'] is String
              ? DateTime.tryParse(map['external_creator_date'])
              : null),
      externalEditorDate: _fromEpochMs(map['external_editor_date']) ??
          (map['external_editor_date'] is String
              ? DateTime.tryParse(map['external_editor_date'])
              : null),
      dwlAddressID: map['DwlAddressID'] as String?,
      dwlQuality: safeInt(map['DwlQuality']),
      dwlFloor: safeInt(map['DwlFloor']),
      dwlApartNumber: map['DwlApartNumber'] as String?,
      dwlStatus: safeInt(map['DwlStatus']),
      dwlYearConstruction: safeInt(map['DwlYearConstruction']),
      dwlYearElimination: safeInt(map['DwlYearElimination']),
      dwlType: safeInt(map['DwlType']),
      dwlOwnership: safeInt(map['DwlOwnership']),
      dwlOccupancy: safeInt(map['DwlOccupancy']),
      dwlSurface: safeInt(map['DwlSurface']),
      dwlToilet: safeInt(map['DwlToilet']),
      dwlBath: safeInt(map['DwlBath']),
      dwlHeatingFacility: safeInt(map['DwlHeatingFacility']),
      dwlHeatingEnergy: safeInt(map['DwlHeatingEnergy']),
      dwlAirConditioner: safeInt(map['DwlAirConditioner']),
      dwlSolarPanel: safeInt(map['DwlSolarPanel']),
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

extension DwellingEntityMapper on DwellingEntity {
  Map<String, dynamic> toMap() {
    return {
      'GlobalID': globalId,
      'OBJECTID': objectId,
      'FeatureId': featureId,
      'GeometryType': geometryType,
      'DwlEntGlobalID': dwlEntGlobalID,
      'DwlCensus2023': dwlCensus2023,
      'external_creator_date': externalCreatorDate?.millisecondsSinceEpoch,
      'external_editor_date': externalEditorDate?.millisecondsSinceEpoch,
      'DwlAddressID': dwlAddressID,
      'DwlQuality': dwlQuality,
      'DwlFloor': dwlFloor,
      'DwlApartNumber': dwlApartNumber,
      'DwlStatus': dwlStatus,
      'DwlYearConstruction': dwlYearConstruction,
      'DwlYearElimination': dwlYearElimination,
      'DwlType': dwlType,
      'DwlOwnership': dwlOwnership,
      'DwlOccupancy': dwlOccupancy,
      'DwlSurface': dwlSurface,
      'DwlToilet': dwlToilet,
      'DwlBath': dwlBath,
      'DwlHeatingFacility': dwlHeatingFacility,
      'DwlHeatingEnergy': dwlHeatingEnergy,
      'DwlAirConditioner': dwlAirConditioner,
      'DwlSolarPanel': dwlSolarPanel,
      'created_user': createdUser,
      'created_date': createdDate?.millisecondsSinceEpoch,
      'last_edited_user': lastEditedUser,
      'last_edited_date': lastEditedDate?.millisecondsSinceEpoch,
      'external_creator': externalCreator,
      'external_editor': externalEditor,
    };
  }
}
