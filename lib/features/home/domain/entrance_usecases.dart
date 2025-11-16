import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/helpers/geometry_helper.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/core/services/json_file_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/entrance_mapper.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/domain/entities/save_result.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/main.dart';
import 'package:latlong2/latlong.dart';

class EntranceUseCases {
  final EntranceRepository _entranceRepository;
  final JsonFileService _jsonFileService = JsonFileService();
  final BuildingUseCases _buildingUseCases;

  EntranceUseCases(this._entranceRepository, this._buildingUseCases);

  Future<List<EntranceEntity>> getEntrances(double zoom,
      List<String> entBldGlobalID, bool isOffline, int? downloadId) async {
    if (zoom < AppConfig.entranceMinZoom) return [];

    if (entBldGlobalID.isEmpty) return [];

    if (!isOffline) {
      return await _entranceRepository.getEntrances(entBldGlobalID);
    } else {
      List<Entrance> entrances = await _entranceRepository
          .getEntrancesByBuildingId(entBldGlobalID, downloadId!);

      return entrances.toEntityList();
    }
  }

  Future<List<EntranceEntity>> getEntrancesByBuildingId(
      String? entBldGlobalID, bool isOffline, int? downloadId) async {
    if (entBldGlobalID == null) return [];

    if (!isOffline) {
      return await _entranceRepository
          .getEntrancesByBuildingIdOnline(entBldGlobalID);
    } else {
      List<Entrance> entrances = await _entranceRepository
          .getEntrancesByBuildingId([entBldGlobalID], downloadId!);

      return entrances.toEntityList();
    }
  }

  Future<EntranceEntity> getEntranceDetails(
    String globalId,
    bool isOffline,
    int? downloadId,
  ) async {
    if (!isOffline) {
      return await _entranceRepository.getEntranceDetails(globalId);
    } else {
      Entrance? entrance =
          await _entranceRepository.getEntranceById(globalId, downloadId!);
      if (entrance == null) {
        throw Exception(
            "Entrance with globalId: $globalId is not found in offline mode!");
      }
      return entrance.toEntity();
    }
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await _jsonFileService.getAttributes('entrance.json');
  }

  Future<String> _addEntranceFeatureOnline(EntranceEntity entrance) async {
    return await _entranceRepository.addEntranceFeature(entrance);
  }

  Future<String> _addEntranceFeatureOffline(
      EntranceEntity entrance, int downloadId) async {
    var driftEntrance = entrance.toDriftEntrance(
        downloadId: downloadId, recordStatus: RecordStatus.added);
    final globalId = await _entranceRepository.insertEntrance(driftEntrance);

    return globalId;
  }

  Future<bool> _updateEntranceFeatureOnline(EntranceEntity entrance) async {
    return await _entranceRepository.updateEntranceFeature(entrance);
  }

  Future<String> _updateEntranceFeatureOffline(
      EntranceEntity entrance, int downloadId) async {
    await _entranceRepository.updateEntranceOffline(entrance.toDriftEntrance(
      downloadId: downloadId,
      recordStatus: RecordStatus.updated,
    ));

    return entrance.globalId ?? '';
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    return await _entranceRepository.deleteEntranceFeature(objectId); //
  }

  Future<SaveResult> saveEntrance(
      EntranceEntity entrance, bool isOffline, int? downloadId) async {
    entrance.entPointStatus = DefaultData.fieldData;
    bool isNewEntrance = entrance.globalId == null;

    if (isNewEntrance) {
      String globalId =
          await _createNewEntrance(entrance, isOffline, downloadId);
      return SaveResult(true, Keys.successAddEntrance, globalId);
    } else {
      await _updateExistingEntrance(entrance, isOffline, downloadId);
      return SaveResult(true, Keys.successUpdateEntrance, entrance.globalId);
    }
  }

  Future<String> _createNewEntrance(
      EntranceEntity entrance, bool isOffline, int? downloadId) async {
    final storageRepository = sl<StorageRepository>();
    final entranceUseCases = sl<EntranceUseCases>();
    final userService = sl<UserService>();
    String? buildingGlobalId = await storageRepository.getString(
      boxName: HiveBoxes.selectedBuilding,
      key: 'currentBuildingGlobalId',
    );

    entrance.entBldGlobalID = buildingGlobalId;
    entrance.externalCreator = '{${userService.userInfo?.nameId}}';
    entrance.externalCreatorDate = DateTime.now();
    entrance.entLatitude = entrance.coordinates?.latitude;
    entrance.entLongitude = entrance.coordinates?.longitude;

    if (!isOffline) {
      return await entranceUseCases._addEntranceFeatureOnline(entrance);
    } else {
      return await entranceUseCases._addEntranceFeatureOffline(
          entrance, downloadId!);
    }
  }

  Future<void> _updateExistingEntrance(
      EntranceEntity entrance, bool isOffline, int? downloadId) async {
    final entranceUseCases = sl<EntranceUseCases>();
    final userService = sl<UserService>();

    entrance.externalEditor = '{${userService.userInfo?.nameId}}';
    entrance.externalEditorDate = DateTime.now();
    entrance.entLatitude = entrance.coordinates?.latitude;
    entrance.entLongitude = entrance.coordinates?.longitude;

    if (!isOffline) {
      await entranceUseCases._updateEntranceFeatureOnline(entrance);
    } else {
      await entranceUseCases._updateEntranceFeatureOffline(
        entrance,
        downloadId!,
      );
    }
  }

  Future<bool> validateEntranceDistanceFromBuilding(
    LatLng entranceCoordinates,
    String buildingGlobalId,
    bool isOffline,
    int? downloadId,
  ) async {
    try {
      final building = await _buildingUseCases.getBuildingDetails(
        buildingGlobalId,
        isOffline,
        downloadId,
      );

      if (building.coordinates.isEmpty) {
        return false;
      }

      return GeometryHelper.validateEntranceDistanceFromBuildingWithTurf(
        entranceCoordinates,
        building.coordinates,
        AppConfig.maxEntranceDistanceFromBuilding,
      );
    } catch (e) {
      print('Warning: Could not validate entrance distance: $e');
      return true;
    }
  }
}
