import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/build_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/dto/building_dto.dart';
import 'package:asrdb/data/repositories/building_repository.dart';
import 'package:asrdb/domain/entities/building_entity.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/main.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';

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

  // Future<bool> getBuildingIntersections(Map<String, dynamic> geometry) async {
  //   return await _buildingRepository.getBuildingIntersections(geometry);
  // }

  Future<String> addBuildingFeature(BuildingEntity building) async {
    final globalId = await _buildingRepository.addBuildingFeature(building);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
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

  Future<void> _setCentroidCoordinates(BuildingEntity building) async {
    final geodesy = Geodesy();
    final centroid = geodesy.findPolygonCentroid(building.coordinates.first);
    building.bldLatitude = centroid.latitude;
    building.bldLongitude = centroid.longitude;
  }

  Future<bool> _validateBuildingOverlap(
      BuildingEntity building, List<BuildingEntity> buildings) async {
    if (buildings.isEmpty) return false;

    final geodesy = Geodesy();
    // Filter out current building by globalId
    final filteredBuildings =
        buildings.where((b) => b.globalId != building.globalId);

    // Flatten all polygon rings
    final polygons =
        filteredBuildings.expand((building) => building.coordinates);
    // expand((building) => building.coordinates
    //     .map((coords) => coords.map((point) => LatLng(point[1], point[0]))));

    // The new polygon points for comparison
    final newPolygonPoints = building.coordinates.first;

    for (final polygon in polygons) {
      final intersectionPoints = geodesy.getPolygonIntersection(
        newPolygonPoints.toList(),
        polygon,
      );

      if (intersectionPoints.isNotEmpty) {
        return false; // Overlap detected
      }
    }

    return true; // No overlap found
  }

  Future<String?> saveBuilding(
    BuildingEntity building,
    List<BuildingEntity> buildings,
    bool isNew,
  ) async {
    building.bldCentroidStatus = DefaultData.fieldData;

    if (building.coordinates.first.isNotEmpty) {
      await _setCentroidCoordinates(building);

      if (!await _validateBuildingOverlap(building, buildings)) {
        return Keys.overlapingBuildings;
      }
    }

    if (isNew) {
      await _createNewBuilding(building);
    } else {
      await _updateExistingBuilding(building);
    }

    return null;
  }

  Future<void> _createNewBuilding(BuildingEntity building) async {
    final buildingCubit = sl<BuildingCubit>();
    final userService = sl<UserService>();

    building.bldMunicipality = userService.userInfo?.municipality;
    building.externalCreator = '{${userService.userInfo?.nameId}}';
    building.externalCreatorDate = DateTime.now();

    await buildingCubit.addBuildingFeature(building);
  }

  Future<void> _updateExistingBuilding(BuildingEntity building) async {
    final buildingCubit = sl<BuildingCubit>();
    final userService = sl<UserService>();
    building.externalCreator = '{${userService.userInfo?.nameId}}';
    building.externalCreatorDate = DateTime.now();

    await buildingCubit.updateBuildingFeature(building);
  }
}
