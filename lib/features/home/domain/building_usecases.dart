import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/constants/default_data.dart';
import 'package:asrdb/core/models/attributes/field_schema.dart';
import 'package:asrdb/core/models/build_fields.dart';
import 'package:asrdb/core/models/general_fields.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/data/building_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/main.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:latlong2/latlong.dart';

class BuildingUseCases {
  final BuildingRepository _buildingRepository;
  final CheckUseCases _checkUseCases;

  BuildingUseCases(
    this._buildingRepository,
    this._checkUseCases,
  );

  Future<Map<String, dynamic>> getBuildings(
      LatLngBounds? bounds, double zoom, int municipalityId) async {
    if (bounds == null) {
      return {};
    }

    if (zoom < EsriConfig.buildingMinZoom) {
      return {};
    }
    return await _buildingRepository.getBuildings(bounds, zoom, municipalityId);
  }

  Future<Map<String, dynamic>> getBuildingDetails(String globalId) async {
    return await _buildingRepository.getBuildingDetails(globalId);
  }

  Future<List<FieldSchema>> getBuildingAttibutes() async {
    return await _buildingRepository.getBuildingAttributes();
  }

  Future<String> addBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng> points) async {
    final globalId =
        await _buildingRepository.addBuildingFeature(attributes, points);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
  }

  Future<String> updateBuildingFeature(
      Map<String, dynamic> attributes, List<LatLng>? points) async {
    final globalId = attributes[GeneralFields.globalID];

    await _buildingRepository.updateBuildingFeature(attributes, points);
    await _checkUseCases.checkAutomatic(
        globalId.toString().replaceAll('{', '').replaceAll('}', ''));
    return globalId;
  }

  Future<bool> startReviewing(String globalId, int value) async {
    var attributes = await getBuildingDetails(globalId);

    if (attributes[BuildFields.bldReview] == 6) {
      attributes[BuildFields.bldReview] = 4;
      await _buildingRepository.updateBuildingFeature(attributes, null);
      return true;
    }

    return false;
  }

  Future<void> _setCentroidCoordinates(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    Geodesy geodesy,
  ) async {
    final centroid = geodesy.findPolygonCentroid(geometryCubit.points);
    attributes[BuildFields.bldLatitude] = centroid.latitude;
    attributes[BuildFields.bldLongitude] = centroid.longitude;
  }

  Map<String, dynamic> _removeFeatureByAttribute(
      String attributeKey, dynamic attributeValue, Map<String, dynamic> data) {
    if (attributeValue == null) return data;
    if (data[GeneralFields.features] == null ||
        data[GeneralFields.features] is! List) {
      return data;
    }

    // Make a deep copy to avoid mutating the original map (optional but safer)
    final Map<String, dynamic> updatedData = Map<String, dynamic>.from(data);
    updatedData[GeneralFields.features] =
        List<dynamic>.from(updatedData[GeneralFields.features]);

    updatedData[GeneralFields.features].removeWhere((feature) {
      final properties = feature[GeneralFields.properties];
      return properties != null && properties[attributeKey] == attributeValue;
    });

    return updatedData;
  }

  List<List<LatLng>> _extractPolygons(Map<String, dynamic> geoJson) {
    final List<List<LatLng>> polygons = [];

    final features = geoJson[GeneralFields.features];
    if (features is! List) return polygons;

    for (final feature in features) {
      final geometry = feature[GeneralFields.geometry];
      if (geometry != null && geometry[GeneralFields.type] == 'Polygon') {
        final coordinates = geometry[GeneralFields.coordinates];

        if (coordinates is List && coordinates.isNotEmpty) {
          final outerRing = coordinates[0]; // Only outer ring
          if (outerRing is List) {
            final polygon = outerRing
                .where((point) => point is List && point.length >= 2)
                .map<LatLng>((point) => LatLng(point[1], point[0])) // lat, lon
                .toList();

            polygons.add(polygon);
          }
        }
      }
    }

    return polygons;
  }

  Future<bool> _validateBuildingOverlap(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    BuildingCubit buildingCubit,
    Geodesy geodesy,
  ) async {
    var buildingsList = (buildingCubit.state as Buildings).buildings;
    var buildings = _removeFeatureByAttribute(GeneralFields.globalID,
        attributes[GeneralFields.globalID], buildingsList);

    var polygons = _extractPolygons(buildings);

    for (int i = 0; i < polygons.length; i++) {
      final polygon = polygons[i];
      var intersectionPoints =
          geodesy.getPolygonIntersection(geometryCubit.points, polygon);

      if (intersectionPoints.isNotEmpty) {
        return false;
      }
    }

    return true;
  }

  Future<String?> saveBuilding(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    BuildingCubit buildingCubit,
    bool isNew,
  ) async {
    final userService = sl<UserService>();
    final geodesy = Geodesy();

    attributes[BuildFields.bldCentroidStatus] = DefaultData.fieldData;

    if (geometryCubit.points.isNotEmpty) {
      await _setCentroidCoordinates(attributes, geometryCubit, geodesy);

      if (!await _validateBuildingOverlap(
          attributes, geometryCubit, buildingCubit, geodesy)) {
        return Keys.overlapingBuildings;
      }
    }

    if (isNew) {
      await _createNewBuilding(
          attributes, geometryCubit, buildingCubit, userService);
    } else {
      await _updateExistingBuilding(
          attributes, geometryCubit, buildingCubit, userService);
    }

    return null;
  }

  Future<void> _createNewBuilding(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    BuildingCubit buildingCubit,
    UserService userService,
  ) async {
    attributes[BuildFields.bldMunicipality] =
        userService.userInfo?.municipality;
    attributes[GeneralFields.externalCreator] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalCreatorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await buildingCubit.addBuildingFeature(attributes, geometryCubit.points);
  }

  Future<void> _updateExistingBuilding(
    Map<String, dynamic> attributes,
    NewGeometryCubit geometryCubit,
    BuildingCubit buildingCubit,
    UserService userService,
  ) async {
    attributes[GeneralFields.externalCreator] =
        '{${userService.userInfo?.nameId}}';
    attributes[GeneralFields.externalCreatorDate] =
        DateTime.now().millisecondsSinceEpoch;

    await buildingCubit.updateBuildingFeature(attributes, geometryCubit.points);
  }
}
