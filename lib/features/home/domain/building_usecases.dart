import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/record_status.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/drift/app_database.dart';
import 'package:asrdb/data/mapper/building_mappers.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/domain/entities/save_result.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/main.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:turf/turf.dart' as turf;
import 'package:asrdb/core/services/json_file_service.dart';

class BuildingUseCases {
  final BuildingRepository _buildingRepository;
  final CheckUseCases _checkUseCases;
  final JsonFileService _jsonFileService = JsonFileService();

  BuildingUseCases(
    this._buildingRepository,
    this._checkUseCases,
  );

  Future<List<BuildingEntity>> getBuildings(
    LatLngBounds? bounds,
    double zoom,
    int municipalityId,
    bool isOffline,
    int? downloadId,
  ) async {
    if (bounds == null) {
      return [];
    }

    if (zoom < AppConfig.buildingMinZoom) {
      return [];
    }

    if (!isOffline) {
      return await _buildingRepository.getBuildingsOnline(
        bounds,
        zoom,
        municipalityId,
      );
    } else {
      List<Building> buildings =
          await _buildingRepository.getBuildingsByDownloadId(downloadId);

      return buildings.toEntityList();
    }
  }

  Future<BuildingEntity> getBuildingDetails(
    String globalId,
    bool isOffline,
    int? downloadId,
  ) async {
    if (!isOffline) {
      return await _buildingRepository.getBuildingDetails(globalId);
    } else {
      Building? building =
          await _buildingRepository.getBuildingById(globalId, downloadId!);
      return building!.toEntity();
    }
  }

  Future<int> getBuildingsCount(LatLngBounds bounds, int municipalityId) async {
    return await _buildingRepository.getBuildingsCount(bounds, municipalityId);
  }

  Future<List<FieldSchema>> getBuildingAttibutes() async {
    return await _jsonFileService.getAttributes('building.json');
  }

  Future<String> _addBuildingFeatureOnline(BuildingEntity building) async {
    final globalId = await _buildingRepository.addBuildingFeature(building);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
  }

  Future<String> _addBuildingFeatureOffline(
      BuildingEntity building, int downloadId) async {
    final globalId = await _buildingRepository.insertBuilding(
        building.toDriftBuilding(
            downloadId: downloadId, recordStatus: RecordStatus.added));

    return globalId;
  }

  Future<String> updateBuildingFeature(BuildingEntity building) async {
    // final globalId = attributes[GeneralFields.globalID];

    await _buildingRepository.updateBuildingFeature(building);
    // await _checkUseCases.checkAutomatic(
    //     building.globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return building.globalId ?? '';
  }

  Future<String> _updateBuildingFeatureOffline(
      BuildingEntity building, int downloadId) async {
    await _buildingRepository.updateBuildingOffline(
      building.toDriftBuilding(
          downloadId: downloadId, recordStatus: RecordStatus.updated),
      downloadId,
    );

    return building.globalId ?? '';
  }

  Future<bool> startReviewing(String globalId, int value) async {
    //revieing is always enabled for online version, so we can set the downloadId to null
    var building = await getBuildingDetails(globalId, false, null);

    if (building.bldReview == 6) {
      building.bldReview = 4;
      await _buildingRepository.updateBuildingFeature(building);
      return true;
    }

    return false;
  }

  Future<void> _setCentroidCoordinates(BuildingEntity building) async {
    final geodesy = Geodesy();
    final centroid = geodesy.findPolygonCentroid(building.coordinates.first);
    building.bldLatitude = centroid.latitude;
    building.bldLongitude = centroid.longitude;
  }

  List<List<LatLng>> _closePolygon(List<List<LatLng>> coords) {
    return coords.map((ring) {
      final copy = List<LatLng>.from(ring);
      if (copy.first != copy.last) {
        copy.add(copy.first);
      }
      return copy;
    }).toList();
  }

  bool isMultipart(List<List<LatLng>> coords) {
    return coords.length > 1;
  }

  List<List<turf.Position>> toTurfCoords(List<List<LatLng>> coords) {
    return coords
        .map((ring) => ring
            .map((latLng) => turf.Position(latLng.longitude, latLng.latitude))
            .toList())
        .toList();
  }

  String? intersectsWithOtherBuildings(
    BuildingEntity building,
    List<BuildingEntity> buildings,
  ) {
    if (buildings.isEmpty) return null;

    // Skip: if the NEW building is multi-part
    if (isMultipart(building.coordinates)) return null;

    final buildingsToCheck = buildings.where(
      (x) => x.globalId!.toLowerCase() != building.globalId!.toLowerCase(),
    );

    List<List<LatLng>> newCoords = _closePolygon(building.coordinates);
    if (isMultipart(newCoords)) {
      return null; // After closing, still multi-part → skip
    }

    final geom1 = turf.Polygon(coordinates: toTurfCoords(newCoords));

    for (final b in buildingsToCheck) {
      final closed = _closePolygon(b.coordinates);

      // Skip other buildings that are multi-part
      if (isMultipart(closed)) continue;

      final geom2 = turf.Polygon(coordinates: toTurfCoords(closed));

      if (turf.booleanIntersects(geom1, geom2)) {
        return b.globalId;
      }
    }

    return null;
  }

  Future<SaveResult> saveBuilding(
      BuildingEntity building, bool offlineMode, int? downloadId) async {
    bool isNewBuilding = building.globalId == null;
    building.bldCentroidStatus = DefaultData.fieldData;

    await _setCentroidCoordinates(building);

    if (isNewBuilding) {
      String globalId =
          await _createNewBuilding(building, offlineMode, downloadId);
      return SaveResult(true, Keys.successAddBuilding, globalId);
    } else {
      await _updateExistingBuilding(building, offlineMode, downloadId);
      return SaveResult(true, Keys.successUpdateBuilding, building.globalId);
    }
  }

  Future<String> _createNewBuilding(
      BuildingEntity building, bool offlineMode, int? downloadId) async {
    final buildingUseCase = sl<BuildingUseCases>();
    final userService = sl<UserService>();

    building.bldMunicipality = userService.userInfo?.municipality;
    building.externalCreator = '{${userService.userInfo?.nameId}}';
    building.externalCreatorDate = DateTime.now();

    if (!offlineMode) {
      return await buildingUseCase._addBuildingFeatureOnline(building);
    } else {
      return await buildingUseCase._addBuildingFeatureOffline(
          building, downloadId!);
    }
  }

  Future<void> _updateExistingBuilding(
      BuildingEntity building, bool offlineMode, int? downloadId) async {
    final buildingUseCase = sl<BuildingUseCases>();
    final userService = sl<UserService>();
    building.externalCreator = '{${userService.userInfo?.nameId}}';
    building.externalCreatorDate = DateTime.now();

    if (!offlineMode) {
      await buildingUseCase.updateBuildingFeature(building);
    } else {
      await buildingUseCase._updateBuildingFeatureOffline(
        building,
        downloadId!,
      );
    }
  }
}
