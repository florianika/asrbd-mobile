import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
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

class BuildingUseCases {
  final BuildingRepository _buildingRepository;
  final CheckUseCases _checkUseCases;

  BuildingUseCases(
    this._buildingRepository,
    this._checkUseCases,
  );

  Future<List<BuildingEntity>> getBuildings(
      LatLngBounds? bounds, double zoom, int municipalityId) async {
    if (bounds == null) {
      return [];
    }

    if (zoom < AppConfig.buildingMinZoom) {
      return [];
    }
    return await _buildingRepository.getBuildings(bounds, zoom, municipalityId);
  }

  Future<BuildingEntity> getBuildingDetails(String globalId) async {
    return await _buildingRepository.getBuildingDetails(globalId);
  }

  Future<int> getBuildingsCount(LatLngBounds bounds, int municipalityId) async {
    return await _buildingRepository.getBuildingsCount(bounds, municipalityId);
  }

  Future<List<FieldSchema>> getBuildingAttibutes() async {
    return await _buildingRepository.getBuildingAttributes();
  }

  Future<String> _addBuildingFeatureOnline(BuildingEntity building) async {
    final globalId = await _buildingRepository.addBuildingFeature(building);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
  }

  Future<String> _addBuildingFeatureOffline(BuildingEntity building) async {   
    final globalId =
        await _buildingRepository.insertBuilding(building.toDriftBuilding(123));

    return '';
  }

  Future<String> updateBuildingFeature(BuildingEntity building) async {
    // final globalId = attributes[GeneralFields.globalID];

    await _buildingRepository.updateBuildingFeature(building);
    await _checkUseCases.checkAutomatic(
        building.globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return building.globalId ?? '';
  }

  Future<bool> startReviewing(String globalId, int value) async {
    var building = await getBuildingDetails(globalId);

    if (building.bldReview == 6) {
      building.bldReview = 4;
      await _buildingRepository.updateBuildingFeature(building);
      return true;
    }

    return false;
  }

  // List<List<turf.Position>> _toTurfCoords(List<List<LatLng>> coords) {
  //   return coords
  //       .map((ring) => ring
  //           .map((latLng) => turf.Position(
  //                   latLng.longitude, latLng.latitude) // turf wants [lng, lat]
  //               )
  //           .toList())
  //       .toList();
  // }

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

  bool intersectsWithOtherBuildings(
    BuildingEntity building,
    List<BuildingEntity> buildings,
  ) {
    if (buildings.isEmpty) return false;

    final buildingsToCheck =
        buildings.where((x) => x.globalId != building.globalId);

    List<List<LatLng>> newBuildingCoordinates =
        _closePolygon(building.coordinates);

    // Convert LatLng list to turf.Position
    List<List<turf.Position>> toTurfCoords(List<List<LatLng>> coords) {
      return coords
          .map((ring) => ring
              .map((latLng) => turf.Position(latLng.longitude, latLng.latitude))
              .toList())
          .toList();
    }

    final geom1 =
        turf.Polygon(coordinates: toTurfCoords(newBuildingCoordinates));

    for (final b in buildingsToCheck) {
      List<List<LatLng>> bCoordinates = _closePolygon(b.coordinates);

      final geom2 = turf.Polygon(coordinates: toTurfCoords(bCoordinates));
      if (turf.booleanIntersects(geom1, geom2)) {
        return true;
      }
    }

    return false;
  }

  Future<SaveResult> saveBuilding(
    BuildingEntity building,
    bool offlineMode,
  ) async {
    bool isNewBuilding = building.globalId == null;
    building.bldCentroidStatus = DefaultData.fieldData;

    await _setCentroidCoordinates(building);

    if (isNewBuilding) {
      String globalId = await _createNewBuilding(building, offlineMode);
      return SaveResult(true, Keys.successAddBuilding, globalId);
    } else {
      await _updateExistingBuilding(building);
      return SaveResult(true, Keys.successUpdateBuilding, building.globalId);
    }
  }

  Future<String> _createNewBuilding(
      BuildingEntity building, bool offlineMode) async {
    final buildingUseCase = sl<BuildingUseCases>();
    final userService = sl<UserService>();

    building.bldMunicipality = userService.userInfo?.municipality;
    building.externalCreator = '{${userService.userInfo?.nameId}}';
    building.externalCreatorDate = DateTime.now();

    if (!offlineMode) {
      return await buildingUseCase._addBuildingFeatureOnline(building);
    } else {
      return await buildingUseCase._addBuildingFeatureOffline(building);
    }
  }

  Future<void> _updateExistingBuilding(BuildingEntity building) async {
    final buildingUseCase = sl<BuildingUseCases>();
    final userService = sl<UserService>();
    building.externalCreator = '{${userService.userInfo?.nameId}}';
    building.externalCreatorDate = DateTime.now();

    await buildingUseCase.updateBuildingFeature(building);
  }
}
