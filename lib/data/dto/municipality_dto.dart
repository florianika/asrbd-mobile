import 'package:asrdb/domain/entities/municipality_entity.dart';
import 'package:latlong2/latlong.dart';

class MunicipalityDto {
  final int objectId;
  final String? geometryType;
  final List<List<List<LatLng>>> coordinates; // MultiPolygon structure

  final double? shapeLength;
  final double? shapeArea;
  final String? idMunicipality;
  final String? nameMunicipality;
  final String? createdUser;
  final DateTime? createdDate;
  final String? lastEditedUser;
  final DateTime? lastEditedDate;
  String? externalCreator;
  final String? externalEditor;
  DateTime? externalCreatorDate;
  DateTime? externalEditorDate;

  MunicipalityDto({
    required this.objectId,
    this.geometryType,
    required this.coordinates,
    this.shapeLength,
    this.shapeArea,
    this.idMunicipality,
    this.nameMunicipality,
    this.createdUser,
    this.createdDate,
    this.lastEditedUser,
    this.lastEditedDate,
    this.externalCreator,
    this.externalEditor,
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

  factory MunicipalityDto.fromMap(Map<String, dynamic> map) {
    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;
    double? safeDouble(dynamic v) => (v is num) ? v.toDouble() : null;

    List<List<List<LatLng>>> parseMultiPolygonCoordinates(dynamic coordsData) {
      final multiPolygon = <List<List<LatLng>>>[];
      if (coordsData is List) {
        for (final polygon in coordsData) {
          final polygonRings = <List<LatLng>>[];
          if (polygon is List) {
            for (final ring in polygon) {
              final ringPoints = <LatLng>[];
              if (ring is List) {
                for (final point in ring) {
                  if (point is Map &&
                      point.containsKey('latitude') &&
                      point.containsKey('longitude')) {
                    final lat = (point['latitude'] as num).toDouble();
                    final lon = (point['longitude'] as num).toDouble();
                    ringPoints.add(LatLng(lat, lon));
                  } else if (point is List && point.length >= 2) {
                    final lat = (point[1] as num).toDouble();
                    final lon = (point[0] as num).toDouble();
                    ringPoints.add(LatLng(lat, lon));
                  }
                }
              }
              polygonRings.add(ringPoints);
            }
          }
          multiPolygon.add(polygonRings);
        }
      }
      return multiPolygon;
    }

    return MunicipalityDto(
      objectId: safeInt(map['OBJECTID']) ?? 0,
      geometryType: map['GeometryType'] as String?,
      coordinates: parseMultiPolygonCoordinates(map['Coordinates']),
      shapeLength: safeDouble(map['ShapeLength']),
      shapeArea: safeDouble(map['ShapeArea']),
      idMunicipality: map['ID_MUNICIPALITY'] as String?,
      nameMunicipality: map['NAME_MUNICIPALITY'] as String?,
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
      externalCreator: map['ExternalCreator'] as String?,
      externalEditor: map['ExternalEditor'] as String?,
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

  factory MunicipalityDto.fromGeoJsonFeature(Map<String, dynamic> feature) {
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final type = geometry['type'] as String?;
    final coordsRaw = geometry['coordinates'];

    final multiPolygon = <List<List<LatLng>>>[];

    void parsePolygon(List<dynamic> rings) {
      final polygonRings = <List<LatLng>>[];
      for (final ring in rings) {
        final ringPoints = <LatLng>[];
        if (ring is List) {
          for (final point in ring) {
            if (point is List && point.length >= 2) {
              final lon = (point[0] as num).toDouble();
              final lat = (point[1] as num).toDouble();
              ringPoints.add(LatLng(lat, lon));
            }
          }
        }
        polygonRings.add(ringPoints);
      }
      multiPolygon.add(polygonRings);
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

    return MunicipalityDto(
      objectId: safeInt(props['OBJECTID']) ?? 0,
      geometryType: type,
      coordinates: multiPolygon,
      shapeLength: safeDouble(props['Shape__Length']),
      shapeArea: safeDouble(props['Shape__Area']),
      idMunicipality: props['ID_MUNICIPALITY'] as String?,
      nameMunicipality: props['NAME_MUNICIPALITY'] as String?,
      createdUser: props['created_user'] as String?,
      createdDate: _fromEpochMs(props['created_date']),
      lastEditedUser: props['last_edited_user'] as String?,
      lastEditedDate: _fromEpochMs(props['last_edited_date']),
      externalCreator: props['external_creator'] as String?,
      externalEditor: props['external_editor'] as String?,
      externalCreatorDate: _fromEpochMs(props['external_creator_date']),
      externalEditorDate: _fromEpochMs(props['external_editor_date']),
    );
  }

  MunicipalityEntity toEntity() {
    return MunicipalityEntity(
      objectId: objectId,
      geometryType: geometryType,
      coordinates: coordinates,
      idMunicipality: idMunicipality,
      nameMunicipality: nameMunicipality,
    );
  }
}
