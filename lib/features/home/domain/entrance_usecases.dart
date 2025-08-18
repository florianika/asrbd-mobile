import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/mapper/entrance_mapper.dart';
import 'package:asrdb/data/repositories/entrance_repository.dart';
import 'package:asrdb/domain/entities/entrance_entity.dart';
import 'package:asrdb/domain/entities/save_result.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/main.dart';

class EntranceUseCases {
  final EntranceRepository _entranceRepository;

  EntranceUseCases(this._entranceRepository);

  Future<List<EntranceEntity>> getEntrances(
      double zoom, List<String> entBldGlobalID) async {
    if (zoom < AppConfig.entranceMinZoom) return [];

    if (entBldGlobalID.isEmpty) return [];

    return await _entranceRepository.getEntrances(zoom, entBldGlobalID);
  }

  Future<EntranceEntity> getEntranceDetails(String globalId) async {
    return await _entranceRepository.getEntranceDetails(globalId);
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await _entranceRepository.getEntranceAttributes();
  }

  Future<String> _addEntranceFeatureOnline(EntranceEntity entrance) async {
    return await _entranceRepository.addEntranceFeature(entrance);
  }

  Future<String> _addEntranceFeatureOffline(EntranceEntity entrance) async {
    final globalId =
        await _entranceRepository.insertEntrance(entrance.toDriftEntrance(123));

    return '';
  }

  Future<bool> _updateEntranceFeatureOnline(EntranceEntity entrance) async {
    return await _entranceRepository.updateEntranceFeature(entrance);
  }

  Future<bool> _updateEntranceFeatureOffline(EntranceEntity entrance) async {
    //return await _entranceRepository.updateEntranceFeature(entrance);
    throw UnimplementedError(
        'Offline update for entrance feature is not implemented yet');
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    return await _entranceRepository.deleteEntranceFeature(objectId); //
  }

  Future<SaveResult> saveEntrance(
      EntranceEntity entrance, bool offlineMode) async {
    entrance.entPointStatus = DefaultData.fieldData;
    bool isNewEntrance = entrance.globalId == null;

    if (isNewEntrance) {
      String globalId = await _createNewEntrance(entrance, offlineMode);
      return SaveResult(true, Keys.successAddEntrance, globalId);
    } else {
      await _updateExistingEntrance(entrance, offlineMode);
      return SaveResult(true, Keys.successUpdateEntrance, entrance.globalId);
    }
  }

  Future<String> _createNewEntrance(
      EntranceEntity entrance, bool offlineMode) async {
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

    if (!offlineMode) {
      return await entranceUseCases._addEntranceFeatureOnline(entrance);
      // await outputLogsCubit.checkAutomatic(
      //     attributes[EntranceFields.entBldGlobalID]
      //         .toString()
      //         .replaceAll('{', '')
      //         .replaceAll('}', ''));
    } else {
      return await entranceUseCases._addEntranceFeatureOffline(entrance);
    }
  }

  Future<void> _updateExistingEntrance(
      EntranceEntity entrance, bool offlineMode) async {
    final entranceUseCases = sl<EntranceUseCases>();
    final userService = sl<UserService>();

    entrance.externalEditor = '{${userService.userInfo?.nameId}}';
    entrance.externalEditorDate = DateTime.now();

    if (!offlineMode) {
      await entranceUseCases._updateEntranceFeatureOnline(entrance);

      // await outputLogsCubit.checkAutomatic(
      //     attributes[EntranceFields.entBldGlobalID]
      //         .toString()
      //         .replaceAll('{', '')
      //         .replaceAll('}', ''));
    } else {
      await entranceUseCases._updateEntranceFeatureOffline(entrance);
    }
  }
}
