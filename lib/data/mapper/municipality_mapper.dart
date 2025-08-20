// lib/data/mappers/municipality_mappers.dart
import 'dart:convert';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/dto/municipality_dto.dart';
import 'package:asrdb/domain/entities/municipality_entity.dart';
import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

// DTO -> MunicipalitiesCompanion
extension MunicipalityDtoToDrift on MunicipalityDto {
  MunicipalitiesCompanion toCompanion() {
    return MunicipalitiesCompanion(
      objectId: Value(objectId),
      coordinates: Value(jsonEncode(coordinates)),
      municipalityId: Value.absentIfNull(idMunicipality),
      municipalityName: Value.absentIfNull(nameMunicipality),
    );
  }
}

var uuid = Uuid();

extension MunicipalityEntityToDrift on MunicipalityEntity {
  Municipality toDriftMunicipality(int downloadId) {
    return Municipality(
      objectId: objectId,
      coordinates: jsonEncode(coordinates),
      municipalityId: idMunicipality ?? '',
      municipalityName: nameMunicipality ?? '',
      downloadId: downloadId,
      id: 0,
    );
  }
}

// Drift row -> Domain entity
extension MunicipalityRowToEntity on Municipality {
  MunicipalityEntity toEntity() {
    // Parse MultiPolygon coordinates structure
    final coordsDecoded = (jsonDecode(coordinates) as List)
        .map<List<List<LatLng>>>((polygon) => (polygon as List)
            .map<List<LatLng>>((ring) => (ring as List).map<LatLng>((point) {
                  final coords = point as List;
                  return LatLng(coords[1], coords[0]); // lat, lon
                }).toList())
            .toList())
        .toList();

    return MunicipalityEntity(
      objectId: objectId,
      geometryType: 'MultiPolygon',
      coordinates: coordsDecoded,
      globalId: '',
      idMunicipality: municipalityId,
      nameMunicipality: municipalityName,
    );
  }
}
