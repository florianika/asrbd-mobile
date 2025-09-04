import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/building_mappers.dart';
import 'package:asrdb/data/mapper/entrance_mapper.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';

class SyncUseCases {
  final BuildingRepository _buildingRepository;
  final EntranceRepository _entranceRepository;
  final DwellingRepository _dwellingRepository;

  SyncUseCases(this._buildingRepository, this._entranceRepository,
      this._dwellingRepository);

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

  Future<void> syncEntrances(List<EntranceEntity> entrances) async {
    if (entrances.isEmpty) return;
    final db = AppDatabase();

    await db.transaction(() async {
      for (final entrance in entrances) {
        try {
          if (entrance.recordStatus == RecordStatus.added) {
            final oldGlobalId = entrance.globalId!;
            final newGlobalId =
                await _entranceRepository.addEntranceFeature(entrance);

            // Run independent DB updates concurrently
            await Future.wait([
              _entranceRepository.updateEntranceEntBldGlobalID(
                globalId: oldGlobalId,
                newEntBldGlobalID: newGlobalId,
              ),
              _dwellingRepository.updateDwellingDwlEntGlobalID(
                  oldDwlEntGlobalID: entrance.globalId!,
                  newDwlEntGlobalID: newGlobalId)
            ]);

            await _entranceRepository.markAsUnchanged(newGlobalId);
          } else {
            await _entranceRepository.updateEntranceFeature(entrance);
            await _entranceRepository.markAsUnchanged(entrance.globalId!);
          }
        } catch (e, st) {
          // Log error, but continue with the next building
          print('Failed to sync building ${entrance.globalId}: $e\n$st');
        }
      }
    });
  }

  Future<void> syncBuildings(List<BuildingEntity> buildings) async {
    if (buildings.isEmpty) return;
    final db = AppDatabase();

    await db.transaction(() async {
      for (final building in buildings) {
        try {
          if (building.recordStatus == RecordStatus.added) {
            final oldGlobalId = building.globalId!;
            final newGlobalId =
                await _buildingRepository.addBuildingFeature(building);

            // Run independent DB updates concurrently
            await Future.wait([
              _entranceRepository.updateEntranceEntBldGlobalID(
                globalId: oldGlobalId,
                newEntBldGlobalID: newGlobalId,
              ),
              _buildingRepository.updateBuildingGlobalId(
                oldGlobalId,
                newGlobalId,
              ),
            ]);

            await _buildingRepository.markAsUnchanged(newGlobalId);
          } else {
            await _buildingRepository.updateBuildingFeature(building);
            await _buildingRepository.markAsUnchanged(building.globalId!);
          }
        } catch (e, st) {
          // Log error, but continue with the next building
          print('Failed to sync building ${building.globalId}: $e\n$st');
        }
      }
    });
  }
}
