import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/domain/entities/dwelling_entity.dart';
import 'package:asrdb/domain/entities/save_result.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/main.dart';

class DwellingUseCases {
  final DwellingRepository _dwellingRepository;
  final CheckUseCases _checkUseCases;

  DwellingUseCases(this._dwellingRepository, this._checkUseCases);

  Future<List<DwellingEntity>> getDwellings(String? entranceGlobalId) async {
    return await _dwellingRepository.getDwellings(entranceGlobalId);
  }

  Future<List<FieldSchema>> getDwellingAttibutes() async {
    return await _dwellingRepository.getDwellingAttributes();
  }

  Future<String> _addDwellingFeatureOnline(DwellingEntity dwelling) async {
    String response = await _dwellingRepository.addDwellingFeature(dwelling);
    return response;
  }

  Future<String> _addDwellingFeatureOffline(DwellingEntity dwelling) async {
    throw UnimplementedError(
        'Offline add for dwelling feature is not implemented yet');
  }

  Future<DwellingEntity> getDwellingDetails(int objectId) async {
    return await _dwellingRepository.getDwellingDetails(objectId);
  }

  Future<bool> _updateDwellingFeatureOnline(
      DwellingEntity dwelling, String buildingGlobalId) async {
    bool response = await _dwellingRepository.updateDwellingFeature(dwelling);
    await _checkUseCases.checkAutomatic(
        buildingGlobalId.toString().replaceAll('{', '').replaceAll('}', ''));

    return response;
  }

  Future<bool> _updateDwellingFeatureOffline(
      DwellingEntity dwelling, String buildingGlobalId) async {
    bool response = await _dwellingRepository.updateDwellingFeature(dwelling);
    await _checkUseCases.checkAutomatic(
        buildingGlobalId.toString().replaceAll('{', '').replaceAll('}', ''));

    return response;
  }

  Future<String> _createNewDwelling(
    DwellingEntity dwelling,
    bool offlineMode,
  ) async {
    final userService = sl<UserService>();
    final dwellingUseCases = sl<DwellingUseCases>();

    dwelling.externalCreator = '{${userService.userInfo?.nameId}}';
    dwelling.externalCreatorDate = DateTime.now();

    if (!offlineMode) {
      return await dwellingUseCases._addDwellingFeatureOnline(dwelling);
    } else {
      return await dwellingUseCases._addDwellingFeatureOffline(dwelling);
    }
  }

  Future<void> _updateExistingDwelling(
      DwellingEntity dwelling, bool offlineMode) async {
    final userService = sl<UserService>();
    final DwellingUseCases dwellingUseCases = sl<DwellingUseCases>();

    dwelling.externalEditor = '{${userService.userInfo?.nameId}}';
    dwelling.externalEditorDate = DateTime.now();

    if (!offlineMode) {
      await dwellingUseCases._updateDwellingFeatureOnline(
          dwelling, dwelling.dwlEntGlobalID!);
    } else {
      await dwellingUseCases._updateDwellingFeatureOffline(
          dwelling, dwelling.dwlEntGlobalID!);
    }
  }

  Future<SaveResult> saveDwelling(
      DwellingEntity dwelling, bool offlineMode) async {
    bool isNewEntrance = dwelling.globalId == null;

    if (isNewEntrance) {
      String globalId = await _createNewDwelling(dwelling, offlineMode);
      return SaveResult(true, Keys.successAddDwelling, globalId);
    } else {
      await _updateExistingDwelling(dwelling, offlineMode);
      return SaveResult(true, Keys.successUpdateDwelling, dwelling.globalId);
    }
  }
}
