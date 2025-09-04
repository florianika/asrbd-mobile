import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/building_mappers.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';

class BuildingSyncUseCases {
  final BuildingRepository _buildingRepository;
  final EntranceRepository _entranceRepository;

  BuildingSyncUseCases(this._buildingRepository, this._entranceRepository);

  Future<List<BuildingEntity>> getBuildingsToSync(int downloadId) async {
    final buildings =
        await _buildingRepository.getUnsyncedBuildings(downloadId);
    return buildings.toEntityList();
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
