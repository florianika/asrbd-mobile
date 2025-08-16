import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:latlong2/latlong.dart';

class DwellingDto {
  final int objectId;
  final String? geometryType;
  final LatLng? coordinates;

  final String? globalId;
  final String? dwlEntGlobalID;
  final String? dwlCensus2023;
  final DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;
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
  final String? externalCreator;
  final String? externalEditor;

  DwellingDto({
    required this.objectId,
    this.geometryType = 'Point',
    this.coordinates,
    this.globalId,
    this.dwlEntGlobalID = '{00000000-0000-0000-0000-000000000000}',
    this.dwlCensus2023 = '99999999999999999',
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

  factory DwellingDto.fromMap(Map<String, dynamic> map) {
    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;

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

    return DwellingDto(
      objectId: safeInt(map['OBJECTID']) ?? 0,
      geometryType: map['GeometryType'] as String?,
      coordinates: parseCoordinates(map['Coordinates']),
      globalId: map['GlobalID'] as String?,
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

  Map<String, dynamic> toGeoJsonFeature() {
    final attributes = <String, dynamic>{};

    // Always include OBJECTID since it's required
    attributes["OBJECTID"] = objectId;

    // Only add non-null attributes
    if (globalId != null) attributes["GlobalID"] = globalId;
    if (dwlEntGlobalID != null) attributes["DwlEntGlobalID"] = dwlEntGlobalID;
    if (dwlCensus2023 != null) attributes["DwlCensus2023"] = dwlCensus2023;
    if (externalCreatorDate != null) {
      attributes["external_creator_date"] =
          externalCreatorDate!.millisecondsSinceEpoch;
    }
    if (externalEditorDate != null) {
      attributes["external_editor_date"] =
          externalEditorDate!.millisecondsSinceEpoch;
    }
    if (dwlAddressID != null) attributes["DwlAddressID"] = dwlAddressID;
    if (dwlQuality != null) attributes["DwlQuality"] = dwlQuality;
    if (dwlFloor != null) attributes["DwlFloor"] = dwlFloor;
    if (dwlApartNumber != null) attributes["DwlApartNumber"] = dwlApartNumber;
    if (dwlStatus != null) attributes["DwlStatus"] = dwlStatus;
    if (dwlYearConstruction != null) {
      attributes["DwlYearConstruction"] = dwlYearConstruction;
    }
    if (dwlYearElimination != null) {
      attributes["DwlYearElimination"] = dwlYearElimination;
    }
    if (dwlType != null) attributes["DwlType"] = dwlType;
    if (dwlOwnership != null) attributes["DwlOwnership"] = dwlOwnership;
    if (dwlOccupancy != null) attributes["DwlOccupancy"] = dwlOccupancy;
    if (dwlSurface != null) attributes["DwlSurface"] = dwlSurface;
    if (dwlToilet != null) attributes["DwlToilet"] = dwlToilet;
    if (dwlBath != null) attributes["DwlBath"] = dwlBath;
    if (dwlHeatingFacility != null) {
      attributes["DwlHeatingFacility"] = dwlHeatingFacility;
    }
    if (dwlHeatingEnergy != null) {
      attributes["DwlHeatingEnergy"] = dwlHeatingEnergy;
    }
    if (dwlAirConditioner != null) {
      attributes["DwlAirConditioner"] = dwlAirConditioner;
    }
    if (dwlSolarPanel != null) attributes["DwlSolarPanel"] = dwlSolarPanel;
    if (createdUser != null) attributes["created_user"] = createdUser;
    if (createdDate != null) {
      attributes["created_date"] = createdDate!.millisecondsSinceEpoch;
    }
    if (lastEditedUser != null) attributes["last_edited_user"] = lastEditedUser;
    if (lastEditedDate != null) {
      attributes["last_edited_date"] = lastEditedDate!.millisecondsSinceEpoch;
    }
    if (externalCreator != null) {
      attributes["external_creator"] = externalCreator;
    }
    if (externalEditor != null) attributes["external_editor"] = externalEditor;

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

  factory DwellingDto.fromGeoJsonFeature(Map<String, dynamic> feature) {
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

    return DwellingDto(
      objectId: safeInt(props['OBJECTID']) ?? 0,
      geometryType: type,
      coordinates: coords,
      globalId: props['GlobalID'] as String?,
      dwlEntGlobalID: props['DwlEntGlobalID'] as String?,
      dwlCensus2023: props['DwlCensus2023'] as String?,
      externalCreatorDate: _fromEpochMs(props['external_creator_date']),
      externalEditorDate: _fromEpochMs(props['external_editor_date']),
      dwlAddressID: props['DwlAddressID'] as String?,
      dwlQuality: safeInt(props['DwlQuality']),
      dwlFloor: safeInt(props['DwlFloor']),
      dwlApartNumber: props['DwlApartNumber'] as String?,
      dwlStatus: safeInt(props['DwlStatus']),
      dwlYearConstruction: safeInt(props['DwlYearConstruction']),
      dwlYearElimination: safeInt(props['DwlYearElimination']),
      dwlType: safeInt(props['DwlType']),
      dwlOwnership: safeInt(props['DwlOwnership']),
      dwlOccupancy: safeInt(props['DwlOccupancy']),
      dwlSurface: safeInt(props['DwlSurface']),
      dwlToilet: safeInt(props['DwlToilet']),
      dwlBath: safeInt(props['DwlBath']),
      dwlHeatingFacility: safeInt(props['DwlHeatingFacility']),
      dwlHeatingEnergy: safeInt(props['DwlHeatingEnergy']),
      dwlAirConditioner: safeInt(props['DwlAirConditioner']),
      dwlSolarPanel: safeInt(props['DwlSolarPanel']),
      createdUser: props['created_user'] as String?,
      createdDate: _fromEpochMs(props['created_date']),
      lastEditedUser: props['last_edited_user'] as String?,
      lastEditedDate: _fromEpochMs(props['last_edited_date']),
      externalCreator: props['external_creator'] as String?,
      externalEditor: props['external_editor'] as String?,
    );
  }

  DwellingEntity toEntity() {
    return DwellingEntity(
      objectId: objectId,
      geometryType: geometryType,
      coordinates: coordinates,
      globalId: globalId,
      dwlEntGlobalID: dwlEntGlobalID,
      dwlCensus2023: dwlCensus2023,
      externalCreatorDate: externalCreatorDate,
      externalEditorDate: externalEditorDate,
      dwlAddressID: dwlAddressID,
      dwlQuality: dwlQuality,
      dwlFloor: dwlFloor,
      dwlApartNumber: dwlApartNumber,
      dwlStatus: dwlStatus,
      dwlYearConstruction: dwlYearConstruction,
      dwlYearElimination: dwlYearElimination,
      dwlType: dwlType,
      dwlOwnership: dwlOwnership,
      dwlOccupancy: dwlOccupancy,
      dwlSurface: dwlSurface,
      dwlToilet: dwlToilet,
      dwlBath: dwlBath,
      dwlHeatingFacility: dwlHeatingFacility,
      dwlHeatingEnergy: dwlHeatingEnergy,
      dwlAirConditioner: dwlAirConditioner,
      dwlSolarPanel: dwlSolarPanel,
      createdUser: createdUser,
      createdDate: createdDate,
      lastEditedUser: lastEditedUser,
      lastEditedDate: lastEditedDate,
      externalCreator: externalCreator,
      externalEditor: externalEditor,
    );
  }

  factory DwellingDto.fromEntity(DwellingEntity entity) {
    return DwellingDto(
      objectId: entity.objectId,
      geometryType: entity.geometryType,
      coordinates: entity.coordinates,
      globalId: entity.globalId,
      dwlEntGlobalID: entity.dwlEntGlobalID,
      dwlCensus2023: entity.dwlCensus2023,
      externalCreatorDate: entity.externalCreatorDate,
      externalEditorDate: entity.externalEditorDate,
      dwlAddressID: entity.dwlAddressID,
      dwlQuality: entity.dwlQuality,
      dwlFloor: entity.dwlFloor,
      dwlApartNumber: entity.dwlApartNumber,
      dwlStatus: entity.dwlStatus,
      dwlYearConstruction: entity.dwlYearConstruction,
      dwlYearElimination: entity.dwlYearElimination,
      dwlType: entity.dwlType,
      dwlOwnership: entity.dwlOwnership,
      dwlOccupancy: entity.dwlOccupancy,
      dwlSurface: entity.dwlSurface,
      dwlToilet: entity.dwlToilet,
      dwlBath: entity.dwlBath,
      dwlHeatingFacility: entity.dwlHeatingFacility,
      dwlHeatingEnergy: entity.dwlHeatingEnergy,
      dwlAirConditioner: entity.dwlAirConditioner,
      dwlSolarPanel: entity.dwlSolarPanel,
      createdUser: entity.createdUser,
      createdDate: entity.createdDate,
      lastEditedUser: entity.lastEditedUser,
      lastEditedDate: entity.lastEditedDate,
      externalCreator: entity.externalCreator,
      externalEditor: entity.externalEditor,
    );
  }
}