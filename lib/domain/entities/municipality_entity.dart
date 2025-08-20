// lib/domain/entities/municipality_entity.dart
import 'package:latlong2/latlong.dart';

class MunicipalityEntity {
  int objectId;
  final String? geometryType;
  final List<List<List<LatLng>>> coordinates; // MultiPolygon structure

  final String? globalId;
  final String? idMunicipality;
  final String? nameMunicipality;

  MunicipalityEntity({
    this.objectId = 0,
    this.geometryType = "MultiPolygon",
    required this.coordinates,
    this.globalId,
    this.idMunicipality,
    this.nameMunicipality,
  });

  factory MunicipalityEntity.fromMap(Map<String, dynamic> map) {
    int? safeInt(dynamic v) => (v is num) ? v.toInt() : null;

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

    return MunicipalityEntity(
      globalId: map['GlobalID'] as String?,
      objectId: safeInt(map['OBJECTID']) ?? 0,
      geometryType: map['GeometryType'] as String?,
      coordinates: parseMultiPolygonCoordinates(map['Coordinates']),
      idMunicipality: map['ID_MUNICIPALITY'] as String?,
      nameMunicipality: map['NAME_MUNICIPALITY'] as String?,
    );
  }
}

extension MunicipalityEntityMapper on MunicipalityEntity {
  Map<String, dynamic> toMap() {
    return {
      'GlobalID': globalId,
      'OBJECTID': objectId,
      'GeometryType': geometryType,
      'Coordinates': coordinates
          .map((polygon) => polygon
              .map((ring) => ring
                  .map((point) => [point.longitude, point.latitude])
                  .toList())
              .toList())
          .toList(),
      'ID_MUNICIPALITY': idMunicipality,
      'NAME_MUNICIPALITY': nameMunicipality,
    };
  }
}
