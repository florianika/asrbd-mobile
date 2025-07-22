import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/entrance/entrance_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/data/entrance_repository.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/main.dart';
import 'package:latlong2/latlong.dart';

class EntranceUseCases {
  final EntranceRepository _entranceRepository;

  EntranceUseCases(this._entranceRepository);

  Future<Map<String, dynamic>> getEntrances(
      double zoom, List<String> entBldGlobalID) async {
    if (zoom < EsriConfig.entranceMinZoom) return {};

    if (entBldGlobalID.isEmpty) return {};

    return await _entranceRepository.getEntrances(zoom, entBldGlobalID);
  }

  Future<Map<String, dynamic>> getEntranceDetails(String globalId) async {
    return await _entranceRepository.getEntranceDetails(globalId);
  }

  Future<List<FieldSchema>> getEntranceAttributes() async {
    return await _entranceRepository.getEntranceAttributes();
  }

  Future<bool> addEntranceFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    return await _entranceRepository.addEntranceFeature(attributes, points);
  }

  Future<bool> updateEntranceFeature(
      Map<String, dynamic> attributes, LatLng? point) async {
    return await _entranceRepository.updateEntranceFeature(attributes, point);
  }

  Future<bool> deleteEntranceFeature(String objectId) async {
    return await _entranceRepository.deleteEntranceFeature(objectId);
  }

  Future<void> saveEntrance(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    EntranceCubit entranceCubit,
    bool isNew,
  ) async {
    final userService = sl<UserService>();
    attributes[EntranceFields.entPointStatus] = DefaultData.fieldData;

    if (isNew) {
      await _createNewEntrance(
          attributes, geometryCubit, entranceCubit, userService);
    } else {
      await _updateExistingEntrance(
          attributes, geometryCubit, entranceCubit, userService);
    }
  }

  Future<void> _createNewEntrance(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    EntranceCubit entranceCubit,
    UserService userService,
  ) async {
    final storageRepository = sl<StorageRepository>();
    String? buildingGlobalId = await storageRepository.getString(
      boxName: HiveBoxes.selectedBuilding,
      key: 'currentBuildingGlobalId',
    );

    attributes[EntranceFields.entBldGlobalID] = buildingGlobalId;
    attributes[GeneralFields.externalCreator] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalCreatorDate] =
        DateTime.now().millisecondsSinceEpoch;
    attributes[EntranceFields.entLatitude] =
        geometryCubit.points.first.latitude;
    attributes[EntranceFields.entLongitude] =
        geometryCubit.points.first.longitude;

    await entranceCubit.addEntranceFeature(attributes, geometryCubit.points);
  }

  Future<void> _updateExistingEntrance(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    EntranceCubit entranceCubit,
    UserService userService,
  ) async {
    attributes[GeneralFields.externalEditor] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalEditorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await entranceCubit.updateEntranceFeature(
      attributes,
      geometryCubit.points.isNotEmpty ? geometryCubit.points.first : null,
    );
  }
}
