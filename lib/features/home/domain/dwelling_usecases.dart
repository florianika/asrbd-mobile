import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:asrdb/main.dart';

class DwellingUseCases {
  final DwellingRepository _dwellingRepository;
  final CheckUseCases _checkUseCases;

  DwellingUseCases(this._dwellingRepository, this._checkUseCases);
  Future<Map<String, dynamic>> getDwellings(String? entranceGlobalId) async {
    return await _dwellingRepository.getDwellings(entranceGlobalId);
  }

  Future<List<FieldSchema>> getDwellingAttibutes() async {
    return await _dwellingRepository.getDwellingAttributes();
  }

  Future<bool> addDwellingFeature(
      Map<String, dynamic> attributes, String buildingGlobalId) async {
    bool response = await _dwellingRepository.addDwellingFeature(attributes);
    await _checkUseCases.checkAutomatic(
        buildingGlobalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return response;
  }

  Future<Map<String, dynamic>> getDwellingDetails(int objectId) async {
    return await _dwellingRepository.getDwellingDetails(objectId);
  }

  Future<bool> updateDwellingFeature(
      Map<String, dynamic> attributes, String buildingGlobalId) async {
    bool response = await _dwellingRepository.updateDwellingFeature(attributes);
    await _checkUseCases.checkAutomatic(
        buildingGlobalId.toString().replaceAll('{', '').replaceAll('}', ''));

    return response;
  }

  Future<void> _createNewDwelling(
    Map<String, dynamic> attributes,
    DwellingCubit dwellingCubit,
    EntranceCubit entranceCubit,
    OutputLogsCubit outputLogsCubit,
    UserService userService,
    String buildingGlobalId,
  ) async {
    attributes[EntranceFields.dwlEntGlobalID] =
        entranceCubit.selectedEntranceGlobalId;
    attributes[GeneralFields.externalCreator] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalCreatorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await dwellingCubit.addDwellingFeature(attributes, buildingGlobalId);
    await outputLogsCubit.checkAutomatic(
        buildingGlobalId.replaceAll('{', '').replaceAll('}', ''));
  }

  Future<void> _updateExistingDwelling(
    Map<String, dynamic> attributes,
    DwellingCubit dwellingCubit,
    OutputLogsCubit outputLogsCubit,
    UserService userService,
    String buildingGlobalId,
  ) async {
    attributes[GeneralFields.externalEditor] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalEditorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await dwellingCubit.updateDwellingFeature(attributes, buildingGlobalId);
    await outputLogsCubit.checkAutomatic(
        buildingGlobalId
            .replaceAll('{', '')
            .replaceAll('}', ''));
  }

  Future<void> saveDwelling(
      Map<String, dynamic> attributes,
      DwellingCubit dwellingCubit,
      EntranceCubit entranceCubit,
      OutputLogsCubit outputLogsCubit,
      String buildingGlobalId,
      bool isNew) async {
    final userService = sl<UserService>();

    if (isNew) {
      await _createNewDwelling(attributes, dwellingCubit, entranceCubit,
          outputLogsCubit, userService, buildingGlobalId);
    } else {
      await _updateExistingDwelling(attributes, dwellingCubit, outputLogsCubit,
          userService, buildingGlobalId);
    }
  }
}
