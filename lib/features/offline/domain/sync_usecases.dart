import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/mapper/building_mappers.dart';
import 'package:asrdb/data/mapper/dwelling_mapper.dart';
import 'package:asrdb/data/mapper/entrance_mapper.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/main.dart';
import 'package:flutter_map/flutter_map.dart';

class SyncUseCases {
  final BuildingRepository _buildingRepository;
  final EntranceRepository _entranceRepository;
  final DwellingRepository _dwellingRepository;
  final DownloadRepository _downloadRepository;

  SyncUseCases(this._buildingRepository, this._entranceRepository,
      this._dwellingRepository, this._downloadRepository);

  Future<List<BuildingEntity>> getBuildingsToSync(int downloadId) async {
    final buildings =
        await _buildingRepository.getUnsyncedBuildings(downloadId);
    return buildings.toEntityList();
  }

  Future<List<EntranceEntity>> getEntrancesToSync(int downloadId) async {
    final entrances =
        await _entranceRepository.getUnsyncedEntrances(downloadId);
    return entrances.toEntityList();
  }

  Future<List<DwellingEntity>> getDwellingsToSync(int downloadId) async {
    final dwellings =
        await _dwellingRepository.getUnsyncedDwellings(downloadId);
    return dwellings.toEntityList();
  }

  Future<bool> updateSyncStatus(int downloadId, bool isSyncSuccess) async {
    final updated =
        await _downloadRepository.updateSyncStatus(downloadId, isSyncSuccess);
    return updated;
  }

  Future<void> downloadAllData(
    int downloadId,
    int municipalityId,
    LatLngBounds downloadBounds,
  ) async {
    final buildingRepository = sl<BuildingRepository>();
    final entranceRepository = sl<EntranceRepository>();
    final dwellingRepository = sl<DwellingRepository>();
    // final userService = sl<UserService>();

    // Download buildings
    var buildings = await buildingRepository.getBuildingsOnline(
      downloadBounds,
      AppConfig.minZoomDownload,
      municipalityId,
    );

    var buildingsDao = buildings.toDriftBuildingList(downloadId);
    await buildingRepository.insertBuildings(buildingsDao);

    // // Download entrances
    List<String> buildingIds =
        buildings.map((entity) => entity.globalId!).toList();

    List<EntranceEntity> entrances =
        await entranceRepository.getEntrances(buildingIds);

    var entrancesDao = entrances.toDriftEntranceList(downloadId);
    await entranceRepository.insertEntrances(entrancesDao);

    // // Download dwellings
    List<String> entrancesIds =
        entrances.map((entity) => entity.globalId!).toList();

    List<DwellingEntity> dwellings =
        await dwellingRepository.getDwellingsByEntrancesList(entrancesIds);

    var dwellingsDao = dwellings.toDriftDwellingList(downloadId);
    await dwellingRepository.insertDwellings(dwellingsDao);
  }

  Future<int> deleteUnmodifiedObjects(int downloadId) async {
    // final db = AppDatabase();
    // return db.transaction(() async {
    final dwellingDeletions =
        await _dwellingRepository.deleteUnmodified(downloadId);
    final entranceDeletions =
        await _entranceRepository.deleteUnmodified(downloadId);
    final buildingDeletions =
        await _buildingRepository.deleteUnmodified(downloadId);

    return buildingDeletions + entranceDeletions + dwellingDeletions;
    // });
  }

  Future<void> syncDwellings(
      List<DwellingEntity> dwellings, int downloadId) async {
    if (dwellings.isEmpty) return;
    // final db =
    //     AppDatabase(); // make sure this is the singleton writable instance

    // await db.transaction(() async {
    for (final dwelling in dwellings) {
      try {
        if (dwelling.recordStatus == RecordStatus.added) {
          final newGlobalId =
              await _dwellingRepository.addDwellingFeature(dwelling);

          await _dwellingRepository.updateDwellingById(
            oldGlobalId: dwelling.globalId!,
            newGlobalId: newGlobalId,
            downloadId: downloadId,
          );

          await _dwellingRepository.markAsUnchanged(newGlobalId, downloadId);
        } else {
          await _dwellingRepository.updateDwellingFeature(dwelling);
          await _dwellingRepository.markAsUnchanged(
              dwelling.globalId!, downloadId);
        }
      } catch (e, st) {
        print('Failed to sync dwelling ${dwelling.globalId}: $e\n$st');
      }
    }
    // });
  }

  Future<void> syncEntrances(
      List<EntranceEntity> entrances, int downloadId) async {
    if (entrances.isEmpty) return;
    // final db =
    //     AppDatabase(); // make sure this is the singleton writable instance

    // await db.transaction(() async {
    for (final entrance in entrances) {
      try {
        if (entrance.recordStatus == RecordStatus.added) {
          final oldGlobalId = entrance.globalId!;
          final newGlobalId =
              await _entranceRepository.addEntranceFeature(entrance);

          // Run dependent DB updates sequentially
          await _entranceRepository.updateEntranceEntBldGlobalID(
            globalId: oldGlobalId,
            newEntBldGlobalID: newGlobalId,
            downloadId: downloadId,
          );

          await _dwellingRepository.updateDwellingDwlEntGlobalID(
            oldDwlEntGlobalID: oldGlobalId,
            newDwlEntGlobalID: newGlobalId,
            downloadId: downloadId,
          );

          await _entranceRepository.markAsUnchanged(newGlobalId, downloadId);
        } else {
          await _entranceRepository.updateEntranceFeature(entrance);
          await _entranceRepository.markAsUnchanged(
              entrance.globalId!, downloadId);
        }
      } catch (e, st) {
        // Log error, but continue with the next entrance
        print('Failed to sync entrance ${entrance.globalId}: $e\n$st');
      }
    }
    // });
  }

  Future<void> syncBuildings(
      List<BuildingEntity> buildings, int downloadId) async {
    if (buildings.isEmpty) return;
    // final db = AppDatabase();

    // await db.transaction(() async {
    for (final building in buildings) {
      try {
        if (building.recordStatus == RecordStatus.added) {
          final oldGlobalId = building.globalId!;
          final newGlobalId =
              await _buildingRepository.addBuildingFeature(building);

          // Run updates sequentially
          await _entranceRepository.updateEntranceEntBldGlobalID(
            globalId: oldGlobalId,
            newEntBldGlobalID: newGlobalId,
            downloadId: downloadId,
          );
          await _buildingRepository.updateBuildingGlobalId(
            oldGlobalId,
            newGlobalId,
            downloadId,
          );

          await _buildingRepository.markAsUnchanged(newGlobalId, downloadId);
        } else {
          await _buildingRepository.updateBuildingFeature(building);
          await _buildingRepository.markAsUnchanged(
              building.globalId!, downloadId);
        }
      } catch (e, st) {
        print('Failed to sync building ${building.globalId}: $e\n$st');
      }
    }
    // });
  }
}
