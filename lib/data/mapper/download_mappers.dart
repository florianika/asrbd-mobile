// lib/data/mappers/building_mappers.dart
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/domain/entities/download_entity.dart';
import 'package:drift/drift.dart';

/// Convert DownloadEntity → Drift row
extension DownloadEntityToDrift on DownloadEntity {
  DownloadsCompanion toDriftDownload({int downloadId = 0}) {
    return DownloadsCompanion(
      areaName: Value.absentIfNull(areaName),
      boundsNorthWestLat: Value.absentIfNull(boundsNorthWestLat),
      boundsNorthWestLng: Value.absentIfNull(boundsNorthWestLng),
      boundsSouthEastLat: Value.absentIfNull(boundsSouthEastLat),
      boundsSouthEastLng: Value.absentIfNull(boundsSouthEastLng),
      centerLat: Value.absentIfNull(centerLat),
      centerLng: Value.absentIfNull(centerLng),
      createdDate: Value.absentIfNull(createdDate),
      email: Value.absentIfNull(email),
      id: Value.absentIfNull(id),
      municipalityId: Value.absentIfNull(municipalityId),
      userId: Value.absentIfNull(userId),
    );
  }
}

/// Convert Drift row → DownloadEntity
extension BuildingRowToEntity on Download {
  DownloadEntity toEntity() {
    return DownloadEntity(
      areaName: areaName,
      boundsNorthWestLat: boundsNorthWestLat,
      boundsNorthWestLng: boundsNorthWestLng,
      boundsSouthEastLat: boundsSouthEastLat,
      boundsSouthEastLng: boundsSouthEastLng,
      centerLat: centerLat,
      centerLng: centerLng,
      createdDate: createdDate,
      email: email,
      id: id,
      municipalityId: municipalityId,
      userId: userId,
    );
  }
}

extension BuildingEntityListToDrift on List<DownloadEntity> {
  List<DownloadsCompanion> toDriftDownloadList(int downloadId) =>
      map((e) => e.toDriftDownload(downloadId: downloadId)).toList();
}

extension BuildingListToEntity on List<Download> {
  List<DownloadEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
