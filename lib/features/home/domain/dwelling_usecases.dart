import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/data/dwelling_repository.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/main.dart';

class DwellingUseCases {
  final DwellingRepository _dwellingRepository;

  DwellingUseCases(this._dwellingRepository);
  Future<Map<String, dynamic>> getDwellings(String? entranceGlobalId) async {
    return await _dwellingRepository.getDwellings(entranceGlobalId);
  }

  Future<List<FieldSchema>> getDwellingAttibutes() async {
    return await _dwellingRepository.getDwellingAttributes();
  }

  Future<bool> addDwellingFeature(Map<String, dynamic> attributes) async {
    return await _dwellingRepository.addDwellingFeature(attributes);
  }

  Future<Map<String, dynamic>> getDwellingDetails(int objectId) async {
    return await _dwellingRepository.getDwellingDetails(objectId);
  }

  Future<bool> updateDwellingFeature(Map<String, dynamic> attributes) async {
    return await _dwellingRepository.updateDwellingFeature(attributes);
  }

  Future<void> _createNewDwelling(
    Map<String, dynamic> attributes,
    DwellingCubit dwellingCubit,
    EntranceCubit entranceCubit,
    UserService userService,
  ) async {
    attributes[EntranceFields.dwlEntGlobalID] =
        entranceCubit.selectedEntranceGlobalId;
    attributes[GeneralFields.externalCreator] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalCreatorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await dwellingCubit.addDwellingFeature(attributes);
  }

  Future<void> _updateExistingDwelling(
    Map<String, dynamic> attributes,
    DwellingCubit dwellingCubit,
    UserService userService,
  ) async {
    attributes[GeneralFields.externalEditor] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalEditorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await dwellingCubit.updateDwellingFeature(attributes);
  }

  Future<void> saveDwelling(
      Map<String, dynamic> attributes,
      DwellingCubit dwellingCubit,
      EntranceCubit entranceCubit,
      bool isNew) async {
    final userService = sl<UserService>();

    if (isNew) {
      await _createNewDwelling(
          attributes, dwellingCubit, entranceCubit, userService);
    } else {
      await _updateExistingDwelling(attributes, dwellingCubit, userService);
    }
  }
}
