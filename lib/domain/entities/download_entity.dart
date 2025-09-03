// lib/domain/entities/download_entity.dart
class DownloadEntity {
  final int? id;
  String? areaName;
  double? boundsNorthWestLat;
  double? boundsNorthWestLng;
  double? boundsSouthEastLat;
  double? boundsSouthEastLng;
  double? centerLat;
  double? centerLng;
  int? municipalityId;
  String? email;
  int? userId;
  DateTime? createdDate;

  DownloadEntity({
    this.id,
    this.areaName,
    this.boundsNorthWestLat,
    this.boundsNorthWestLng,
    this.boundsSouthEastLat,
    this.boundsSouthEastLng,
    this.centerLat,
    this.centerLng,
    this.municipalityId,
    this.email,
    this.userId,
    this.createdDate,
  });
}
