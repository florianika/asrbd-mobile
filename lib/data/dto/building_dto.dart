import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:latlong2/latlong.dart';

class BuildingDto {
  final int objectId;
  final String? geometryType;
  final List<List<LatLng>> coordinates;

  final double? shapeLength;
  final double? shapeArea;
  final String? globalId;
  final String? bldCensus2023;
  final int? bldQuality;
  final int? bldMunicipality;
  final String? bldEnumArea;
  final double? bldLatitude;
  final double? bldLongitude;
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
  final int? bldCentroidStatus;
  final int? bldDwellingRecs;
  final int? bldEntranceRecs;
  final String? bldAddressID;
  String? externalCreator;
  final String? externalEditor;
  final int? bldReview;
  final int? bldWaterSupply;
  DateTime? externalCreatorDate;
  DateTime? externalEditorDate;

  BuildingDto({
    required this.objectId,
    this.geometryType,
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
    this.bldReview,
    this.bldWaterSupply,
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

  factory BuildingDto.fromMap(Map<String, dynamic> map) {
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

    return BuildingDto(
      objectId: safeInt(map['OBJECTID']) ?? 0,
      geometryType: map['GeometryType'] as String?,
      coordinates: parseCoordinates(map['Coordinates']),
      shapeLength: safeDouble(map['ShapeLength']),
      shapeArea: safeDouble(map['ShapeArea']),
      globalId: map['GlobalId'] as String?,
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

  Map<String, dynamic> toGeoJsonFeature() {
    final attributes = <String, dynamic>{};

    // Always include OBJECTID since it's required
    attributes["OBJECTID"] = objectId;

    // Only add non-null attributes
    if (shapeLength != null) attributes["Shape__Length"] = shapeLength;
    if (shapeArea != null) attributes["Shape__Area"] = shapeArea;
    if (globalId != null) attributes["GlobalID"] = globalId;
    if (bldCensus2023 != null) attributes["BldCensus2023"] = bldCensus2023;
    if (bldQuality != null) attributes["BldQuality"] = bldQuality;
    if (bldMunicipality != null) {
      attributes["BldMunicipality"] = bldMunicipality;
    }
    if (bldEnumArea != null) attributes["BldEnumArea"] = bldEnumArea;
    if (bldLatitude != null) attributes["BldLatitude"] = bldLatitude;
    if (bldLongitude != null) attributes["BldLongitude"] = bldLongitude;
    if (bldCadastralZone != null) {
      attributes["BldCadastralZone"] = bldCadastralZone;
    }
    if (bldProperty != null) attributes["BldProperty"] = bldProperty;
    if (bldPermitNumber != null) {
      attributes["BldPermitNumber"] = bldPermitNumber;
    }
    if (bldPermitDate != null) {
      attributes["BldPermitDate"] = bldPermitDate!.microsecondsSinceEpoch;
    }
    if (bldStatus != null) attributes["BldStatus"] = bldStatus;
    if (bldYearConstruction != null) {
      attributes["BldYearConstruction"] = bldYearConstruction;
    }
    if (bldYearDemolition != null) {
      attributes["BldYearDemolition"] = bldYearDemolition;
    }
    if (bldType != null) attributes["BldType"] = bldType;
    if (bldClass != null) attributes["BldClass"] = bldClass;
    if (bldArea != null) attributes["BldArea"] = bldArea;
    if (bldFloorsAbove != null) attributes["BldFloorsAbove"] = bldFloorsAbove;
    if (bldHeight != null) attributes["BldHeight"] = bldHeight;
    if (bldVolume != null) attributes["BldVolume"] = bldVolume;
    if (bldWasteWater != null) attributes["BldWasteWater"] = bldWasteWater;
    if (bldElectricity != null) attributes["BldElectricity"] = bldElectricity;
    if (bldPipedGas != null) attributes["BldPipedGas"] = bldPipedGas;
    if (bldElevator != null) attributes["BldElevator"] = bldElevator;
    if (createdUser != null) attributes["created_user"] = createdUser;
    if (createdDate != null) {
      attributes["created_date"] = createdDate!.millisecondsSinceEpoch;
    }
    if (lastEditedUser != null) attributes["last_edited_user"] = lastEditedUser;
    if (lastEditedDate != null) {
      attributes["last_edited_date"] = lastEditedDate!.microsecondsSinceEpoch;
    }
    if (bldCentroidStatus != null) {
      attributes["BldCentroidStatus"] = bldCentroidStatus;
    }
    if (bldDwellingRecs != null) {
      attributes["BldDwellingRecs"] = bldDwellingRecs;
    }
    if (bldEntranceRecs != null) {
      attributes["BldEntranceRecs"] = bldEntranceRecs;
    }
    if (bldAddressID != null) attributes["BldAddressID"] = bldAddressID;
    if (externalCreator != null) {
      attributes["external_creator"] = externalCreator;
    }
    if (externalEditor != null) attributes["external_editor"] = externalEditor;
    if (bldReview != null) attributes["BldReview"] = bldReview;
    if (bldWaterSupply != null) attributes["BldWaterSupply"] = bldWaterSupply;
    if (externalCreatorDate != null) {
      attributes["external_creator_date"] =
          externalCreatorDate!.millisecondsSinceEpoch;
    }
    if (externalEditorDate != null) {
      attributes["external_editor_date"] =
          externalEditorDate!.millisecondsSinceEpoch;
    }

    return {
      "type": "Feature",
      "geometry": {
        "rings": coordinates
            .map((ring) =>
                ring.map((point) => [point.longitude, point.latitude]).toList())
            .toList(),
        'spatialReference': {'wkid': 4326},
      },
      "attributes": attributes
    };
  }

  factory BuildingDto.fromGeoJsonFeature(Map<String, dynamic> feature) {
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final type = geometry['type'] as String?;
    final coordsRaw = geometry['coordinates'];

    final coords = <List<LatLng>>[];

    void parsePolygon(List<dynamic> rings) {
      for (final ring in rings) {
        final listRing = <LatLng>[];
        if (ring is List) {
          for (final point in ring) {
            if (point is List && point.length >= 2) {
              final lon = (point[0] as num).toDouble();
              final lat = (point[1] as num).toDouble();
              listRing.add(LatLng(lat, lon));
            }
          }
        }
        coords.add(listRing);
      }
    }

    if (type == 'Polygon' && coordsRaw is List) {
      parsePolygon(coordsRaw);
    } else if (type == 'MultiPolygon' && coordsRaw is List) {
      for (final polygon in coordsRaw) {
        if (polygon is List) parsePolygon(polygon);
      }
    }

    final props = feature['properties'] as Map<String, dynamic>? ?? {};

    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;
    double? safeDouble(dynamic v) => (v is num) ? v.toDouble() : null;

    return BuildingDto(
      objectId: safeInt(props['OBJECTID']) ?? 0,
      geometryType: type,
      coordinates: coords,
      shapeLength: null, //safeDouble(props['Shape__Length']),
      shapeArea: null, //safeDouble(props['Shape__Area']),
      globalId: props['GlobalID'] as String?,
      bldCensus2023: props['BldCensus2023'] as String?,
      bldQuality: safeInt(props['BldQuality']),
      bldMunicipality: safeInt(props['BldMunicipality']),
      bldEnumArea: props['BldEnumArea'] as String?,
      bldLatitude: safeDouble(props['BldLatitude']),
      bldLongitude: safeDouble(props['BldLongitude']),
      bldCadastralZone: safeInt(props['BldCadastralZone']),
      bldProperty: props['BldProperty'] as String?,
      bldPermitNumber: props['BldPermitNumber'] as String?,
      bldPermitDate: _fromEpochMs(props['BldPermitDate']),
      bldStatus: safeInt(props['BldStatus']),
      bldYearConstruction: safeInt(props['BldYearConstruction']),
      bldYearDemolition: safeInt(props['BldYearDemolition']),
      bldType: safeInt(props['BldType']),
      bldClass: safeInt(props['BldClass']),
      bldArea: safeDouble(props['BldArea']),
      bldFloorsAbove: safeInt(props['BldFloorsAbove']),
      bldHeight: safeDouble(props['BldHeight']),
      bldVolume: safeDouble(props['BldVolume']),
      bldWasteWater: safeInt(props['BldWasteWater']),
      bldElectricity: safeInt(props['BldElectricity']),
      bldPipedGas: safeInt(props['BldPipedGas']),
      bldElevator: safeInt(props['BldElevator']),
      createdUser: props['created_user'] as String?,
      createdDate: _fromEpochMs(props['created_date']),
      lastEditedUser: props['last_edited_user'] as String?,
      lastEditedDate: _fromEpochMs(props['last_edited_date']),
      bldCentroidStatus: safeInt(props['BldCentroidStatus']),
      bldDwellingRecs: safeInt(props['BldDwellingRecs']),
      bldEntranceRecs: safeInt(props['BldEntranceRecs']),
      bldAddressID: props['BldAddressID'],
      externalCreator: props['external_creator'] as String?,
      externalEditor: props['external_editor'] as String?,
      bldReview: safeInt(props['BldReview']),
      bldWaterSupply: safeInt(props['BldWaterSupply']),
      externalCreatorDate: _fromEpochMs(props['external_creator_date']),
      externalEditorDate: _fromEpochMs(props['external_editor_date']),
    );
  }

  BuildingEntity toEntity() {
    return BuildingEntity(
      objectId: objectId,
      geometryType: geometryType,
      coordinates: coordinates,
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
      createdUser: createdUser,
      createdDate: createdDate,
      lastEditedUser: lastEditedUser,
      lastEditedDate: lastEditedDate,
      bldCentroidStatus: bldCentroidStatus,
      bldDwellingRecs: bldDwellingRecs,
      bldEntranceRecs: bldEntranceRecs,
      bldAddressID: bldAddressID,
      externalCreator: externalCreator,
      externalEditor: externalEditor,
      bldReview: bldReview,
      bldWaterSupply: bldWaterSupply,
      externalCreatorDate: externalCreatorDate,
      externalEditorDate: externalEditorDate,
    );
  }

  factory BuildingDto.fromEntity(BuildingEntity entity) {
    return BuildingDto(
      objectId: entity.objectId,
      geometryType: entity.geometryType,
      coordinates: entity.coordinates,
      shapeLength: entity.shapeLength,
      shapeArea: entity.shapeArea,
      globalId: entity.globalId,
      bldCensus2023: entity.bldCensus2023,
      bldQuality: entity.bldQuality,
      bldMunicipality: entity.bldMunicipality,
      bldEnumArea: entity.bldEnumArea,
      bldLatitude: entity.bldLatitude,
      bldLongitude: entity.bldLongitude,
      bldCadastralZone: entity.bldCadastralZone,
      bldProperty: entity.bldProperty,
      bldPermitNumber: entity.bldPermitNumber,
      bldPermitDate: entity.bldPermitDate,
      bldStatus: entity.bldStatus,
      bldYearConstruction: entity.bldYearConstruction,
      bldYearDemolition: entity.bldYearDemolition,
      bldType: entity.bldType,
      bldClass: entity.bldClass,
      bldArea: entity.bldArea,
      bldFloorsAbove: entity.bldFloorsAbove,
      bldHeight: entity.bldHeight,
      bldVolume: entity.bldVolume,
      bldWasteWater: entity.bldWasteWater,
      bldElectricity: entity.bldElectricity,
      bldPipedGas: entity.bldPipedGas,
      bldElevator: entity.bldElevator,
      createdUser: entity.createdUser,
      createdDate: entity.createdDate,
      lastEditedUser: entity.lastEditedUser,
      lastEditedDate: entity.lastEditedDate,
      bldCentroidStatus: entity.bldCentroidStatus,
      bldDwellingRecs: entity.bldDwellingRecs,
      bldEntranceRecs: entity.bldEntranceRecs,
      bldAddressID: entity.bldAddressID,
      externalCreator: entity.externalCreator,
      externalEditor: entity.externalEditor,
      bldReview: entity.bldReview,
      bldWaterSupply: entity.bldWaterSupply,
      externalCreatorDate: entity.externalCreatorDate,
      externalEditorDate: entity.externalEditorDate,
    );
  }

  Map<String, dynamic> toEsriFeature() {
    return {
      "geometry": {
        "rings": coordinates
            .map((ring) =>
                ring.map((point) => [point.longitude, point.latitude]).toList())
            .toList(),
        "spatialReference": {"wkid": 4326}
      },
      "attributes": {
        "OBJECTID": objectId,
        "Shape__Length": shapeLength,
        "Shape__Area": shapeArea,
        "GlobalID": globalId,
        "BldCensus2023": bldCensus2023,
        "BldQuality": bldQuality,
        "BldMunicipality": bldMunicipality,
        "BldEnumArea": bldEnumArea,
        "BldLatitude": bldLatitude,
        "BldLongitude": bldLongitude,
        "BldCadastralZone": bldCadastralZone,
        "BldProperty": bldProperty,
        "BldPermitNumber": bldPermitNumber,
        "BldPermitDate": bldPermitDate?.millisecondsSinceEpoch,
        "BldStatus": bldStatus,
        "BldYearConstruction": bldYearConstruction,
        "BldYearDemolition": bldYearDemolition,
        "BldType": bldType,
        "BldClass": bldClass,
        "BldArea": bldArea,
        "BldFloorsAbove": bldFloorsAbove,
        "BldHeight": bldHeight,
        "BldVolume": bldVolume,
        "BldWasteWater": bldWasteWater,
        "BldElectricity": bldElectricity,
        "BldPipedGas": bldPipedGas,
        "BldElevator": bldElevator,
        "created_user": createdUser,
        "created_date": createdDate?.millisecondsSinceEpoch,
        "last_edited_user": lastEditedUser,
        "last_edited_date": lastEditedDate?.millisecondsSinceEpoch,
        "BldCentroidStatus": bldCentroidStatus,
        "BldDwellingRecs": bldDwellingRecs,
        "BldEntranceRecs": bldEntranceRecs,
        "BldAddressID": bldAddressID,
        "external_creator": externalCreator,
        "external_editor": externalEditor,
        "BldReview": bldReview,
        "BldWaterSupply": bldWaterSupply,
        "external_creator_date": externalCreatorDate?.millisecondsSinceEpoch,
        "external_editor_date": externalEditorDate?.millisecondsSinceEpoch,
      }
    };
  }
}
