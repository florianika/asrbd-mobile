// lib/domain/entities/building_entity.dart
import 'package:latlong2/latlong.dart';

class BuildingEntity {
  int objectId;
  final int? featureId;
  final String? geometryType;
  final List<List<LatLng>> coordinates;

  final double? shapeLength;
  final double? shapeArea;
  final String? globalId;
  final String? bldCensus2023;
  final int? bldQuality;
  int? bldMunicipality;
  final String? bldEnumArea;
  double? bldLatitude;
  double? bldLongitude;
  final int? bldCadastralZone;
  final String? bldProperty;
  final String? bldPermitNumber;
  final DateTime? bldPermitDate;
  final int? bldStatus;
  final int? bldYearConstruction;
  final int? bldYearDemolition;
  final int? bldType;
  final int? bldClass;
  final double? bldArea;
  final int? bldFloorsAbove;
  final double? bldHeight;
  final double? bldVolume;
  final int? bldWasteWater;
  final int? bldElectricity;
  final int? bldPipedGas;
  final int? bldElevator;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  int? bldCentroidStatus;
  final int? bldDwellingRecs;
  final int? bldEntranceRecs;
  final String? bldAddressID;
  String? externalCreator;
  final String? externalEditor;
  int? bldReview;
  final int? bldWaterSupply;
  DateTime? externalCreatorDate;
  final DateTime? externalEditorDate;

  BuildingEntity({
    this.objectId = 0,
    this.featureId,
    this.geometryType = "Polygon",
    required this.coordinates,
    this.shapeLength,
    this.shapeArea,
    this.globalId,
    this.bldCensus2023 = '99999999999',
    this.bldQuality = 9,
    this.bldMunicipality,
    this.bldEnumArea,
    this.bldLatitude,
    this.bldLongitude,
    this.bldCadastralZone,
    this.bldProperty,
    this.bldPermitNumber,
    this.bldPermitDate,
    this.bldStatus = 4,
    this.bldYearConstruction,
    this.bldYearDemolition,
    this.bldType = 9,
    this.bldClass = 999,
    this.bldArea,
    this.bldFloorsAbove,
    this.bldHeight,
    this.bldVolume,
    this.bldWasteWater = 9,
    this.bldElectricity = 9,
    this.bldPipedGas = 9,
    this.bldElevator = 9,
    this.createdUser,
    this.createdDate,
    this.lastEditedUser,
    this.lastEditedDate,
    this.bldCentroidStatus = 1,
    this.bldDwellingRecs,
    this.bldEntranceRecs,
    this.bldAddressID,
    this.externalCreator,
    this.externalEditor,
    this.bldReview = 1,
    this.bldWaterSupply = 99,
    this.externalCreatorDate,
    this.externalEditorDate,
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

  factory BuildingEntity.fromMap(Map<String, dynamic> map) {
    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;
    double? safeDouble(dynamic v) => (v is num) ? v.toDouble() : null;

    List<List<LatLng>> parseCoordinates(dynamic coordsData) {
      final coords = <List<LatLng>>[];
      if (coordsData is List) {
        for (final ring in coordsData) {
          final listRing = <LatLng>[];
          if (ring is List) {
            for (final point in ring) {
              if (point is Map &&
                  point.containsKey('latitude') &&
                  point.containsKey('longitude')) {
                final lat = (point['latitude'] as num).toDouble();
                final lon = (point['longitude'] as num).toDouble();
                listRing.add(LatLng(lat, lon));
              } else if (point is List && point.length >= 2) {
                final lat = (point[1] as num).toDouble();
                final lon = (point[0] as num).toDouble();
                listRing.add(LatLng(lat, lon));
              }
            }
          }
          coords.add(listRing);
        }
      }
      return coords;
    }

    return BuildingEntity(
      globalId: map['GlobalID'] as String?,
      objectId: safeInt(map['OBJECTID']) ?? 0,
      featureId: safeInt(map['FeatureId']),
      geometryType: map['GeometryType'] as String?,
      coordinates: parseCoordinates(map['Coordinates']),
      shapeLength: safeDouble(map['ShapeLength']),
      shapeArea: safeDouble(map['ShapeArea']),
      bldCensus2023: map['BldCensus2023'] as String?,
      bldQuality: safeInt(map['BldQuality']),
      bldMunicipality: safeInt(map['BldMunicipality']),
      bldEnumArea: map['BldEnumArea'] as String?,
      bldLatitude: safeDouble(map['BldLatitude']),
      bldLongitude: safeDouble(map['BldLongitude']),
      bldCadastralZone: safeInt(map['BldCadastralZone']),
      bldProperty: map['BldProperty'] as String?,
      bldPermitNumber: map['BldPermitNumber'] as String?,
      bldPermitDate: _fromEpochMs(map['BldPermitDate']) ??
          (map['BldPermitDate'] is String
              ? DateTime.tryParse(map['BldPermitDate'])
              : null),
      bldStatus: safeInt(map['BldStatus']),
      bldYearConstruction: safeInt(map['BldYearConstruction']),
      bldYearDemolition: safeInt(map['BldYearDemolition']),
      bldType: safeInt(map['BldType']),
      bldClass: safeInt(map['BldClass']),
      bldArea: safeDouble(map['BldArea']),
      bldFloorsAbove: safeInt(map['BldFloorsAbove']),
      bldHeight: safeDouble(map['BldHeight']),
      bldVolume: safeDouble(map['BldVolume']),
      bldWasteWater: safeInt(map['BldWasteWater']),
      bldElectricity: safeInt(map['BldElectricity']),
      bldPipedGas: safeInt(map['BldPipedGas']),
      bldElevator: safeInt(map['BldElevator']),
      createdUser: map['CreatedUser'] as String?,
      createdDate: _fromEpochMs(map['CreatedDate']) ??
          (map['CreatedDate'] is String
              ? DateTime.tryParse(map['CreatedDate'])
              : null),
      lastEditedUser: map['LastEditedUser'] as String?,
      lastEditedDate: _fromEpochMs(map['LastEditedDate']) ??
          (map['LastEditedDate'] is String
              ? DateTime.tryParse(map['LastEditedDate'])
              : null),
      bldCentroidStatus: safeInt(map['BldCentroidStatus']),
      bldDwellingRecs: safeInt(map['BldDwellingRecs']),
      bldEntranceRecs: safeInt(map['BldEntranceRecs']),
      bldAddressID: map['BldAddressID'] as String?,
      externalCreator: map['ExternalCreator'] as String?,
      externalEditor: map['ExternalEditor'] as String?,
      bldReview: safeInt(map['BldReview']),
      bldWaterSupply: safeInt(map['BldWaterSupply']),
      externalCreatorDate: _fromEpochMs(map['ExternalCreatorDate']) ??
          (map['ExternalCreatorDate'] is String
              ? DateTime.tryParse(map['ExternalCreatorDate'])
              : null),
      externalEditorDate: _fromEpochMs(map['ExternalEditorDate']) ??
          (map['ExternalEditorDate'] is String
              ? DateTime.tryParse(map['ExternalEditorDate'])
              : null),
    );
  }
}

extension BuildingEntityMapper on BuildingEntity {
  Map<String, dynamic> toMap() {
    return {
      'GlobalID': globalId,
      'OBJECTID': objectId,
      'FeatureId': featureId,
      'GeometryType': geometryType,
      'Coordinates': coordinates
          .map((ring) =>
              ring.map((point) => [point.longitude, point.latitude]).toList())
          .toList(),
      'Shape__Length': shapeLength,
      'Shape__Area': shapeArea,
      'BldCensus2023': bldCensus2023,
      'BldQuality': bldQuality,
      'BldMunicipality': bldMunicipality,
      'BldEnumArea': bldEnumArea,
      'BldLatitude': bldLatitude,
      'BldLongitude': bldLongitude,
      'BldCadastralZone': bldCadastralZone,
      'BldProperty': bldProperty,
      'BldPermitNumber': bldPermitNumber,
      'BldPermitDate': bldPermitDate?.millisecondsSinceEpoch,
      'BldStatus': bldStatus,
      'BldYearConstruction': bldYearConstruction,
      'BldYearDemolition': bldYearDemolition,
      'BldType': bldType,
      'BldClass': bldClass,
      'BldArea': bldArea,
      'BldFloorsAbove': bldFloorsAbove,
      'BldHeight': bldHeight,
      'BldVolume': bldVolume,
      'BldWasteWater': bldWasteWater,
      'BldElectricity': bldElectricity,
      'BldPipedGas': bldPipedGas,
      'BldElevator': bldElevator,
      'created_user': createdUser,
      'created_date': createdDate?.millisecondsSinceEpoch,
      'last_edited_user': lastEditedUser,
      'last_edited_date': lastEditedDate?.millisecondsSinceEpoch,
      'BldCentroidStatus': bldCentroidStatus,
      'BldDwellingRecs': bldDwellingRecs,
      'BldEntranceRecs': bldEntranceRecs,
      'BldAddressID': bldAddressID,
      'external_creator': externalCreator,
      'external_editor': externalEditor,
      'BldReview': bldReview,
      'BldWaterSupply': bldWaterSupply,
      'external_creator_date': externalCreatorDate?.millisecondsSinceEpoch,
      'external_editor_date': externalEditorDate?.millisecondsSinceEpoch,
    };
  }
}
