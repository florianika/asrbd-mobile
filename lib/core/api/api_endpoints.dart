import 'package:asrdb/core/config/esri_config.dart';
import 'package:asrdb/core/enums/entity_type.dart';

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String loginEsri = '/auth/gis/login';
  static const String refreshToken = '/auth/refreshToken';
  static const String register = '/auth/register';
  static const String userProfile = '/user/profile';

  static Uri esriBaseUri = Uri(
    scheme: 'https',
    host: "salstatstaging.tddev.it",
    path: '/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/',
  );

  static String getEsriBulding(String geometry) {
    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/1/query',
      queryParameters: {
        'where': '1=1',
        'objectIds': '',
        'time': '',
        'geometry': geometry,
        'geometryType': 'esriGeometryEnvelope',
        'inSR': '4326',
        'defaultSR': '',
        'spatialRel': 'esriSpatialRelIntersects',
        'distance': '',
        'units': 'esriSRUnit_Foot',
        'relationParam': '',
        'outFields': '*',
        'returnGeometry': 'true',
        'maxAllowableOffset': '',
        'geometryPrecision': '',
        'outSR': '',
        'havingClause': '',
        'gdbVersion': '',
        'historicMoment': '',
        'returnDistinctValues': 'false',
        'returnIdsOnly': 'false',
        'returnCountOnly': 'false',
        'returnExtentOnly': 'false',
        'orderByFields': '',
        'groupByFieldsForStatistics': '',
        'outStatistics': '',
        'returnZ': 'false',
        'returnM': 'false',
        'multipatchOption': 'xyFootprint',
        'resultOffset': '',
        'resultRecordCount': '',
        'returnTrueCurves': 'false',
        'returnExceededLimitFeatures': 'false',
        'quantizationParameters': '',
        'returnCentroid': 'false',
        'timeReferenceUnknownClient': 'false',
        'maxRecordCountFactor': '',
        'sqlFormat': 'none',
        'resultType': '',
        'featureEncoding': 'esriDefault',
        'datumTransformation': '',
        'f': 'geojson',
      },
    ).toString();
  }

  static String getEsriEntrance(String geometry) {
    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/0/query',
      queryParameters: {
        'where': '1=1',
        'objectIds': '',
        'time': '',
        'geometry': geometry,
        'geometryType': 'esriGeometryEnvelope',
        'inSR': '4326',
        'defaultSR': '',
        'spatialRel': 'esriSpatialRelIntersects',
        'distance': '',
        'units': 'esriSRUnit_Foot',
        'relationParam': '',
        'outFields': 'OBJECTID,EntQuality,EntBldGlobalID',
        'returnGeometry': 'true',
        'maxAllowableOffset': '',
        'geometryPrecision': '',
        'outSR': '',
        'havingClause': '',
        'gdbVersion': '',
        'historicMoment': '',
        'returnDistinctValues': 'false',
        'returnIdsOnly': 'false',
        'returnCountOnly': 'false',
        'returnExtentOnly': 'false',
        'orderByFields': '',
        'groupByFieldsForStatistics': '',
        'outStatistics': '',
        'returnZ': 'false',
        'returnM': 'false',
        'multipatchOption': 'xyFootprint',
        'resultOffset': '',
        'resultRecordCount': '',
        'returnTrueCurves': 'false',
        'returnExceededLimitFeatures': 'false',
        'quantizationParameters': '',
        'returnCentroid': 'false',
        'timeReferenceUnknownClient': 'false',
        'maxRecordCountFactor': '',
        'sqlFormat': 'none',
        'resultType': '',
        'featureEncoding': 'esriDefault',
        'datumTransformation': '',
        'f': 'geojson',
      },
    ).toString();
  }

  static String getEsriEntranceByObjectId(int objectId) {
    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/0/query',
      queryParameters: {
        'where': '',
        'objectIds': [objectId.toString()],
        'time': '',
        'geometry': '',
        'geometryType': 'esriGeometryEnvelope',
        'inSR': '4326',
        'defaultSR': '',
        'spatialRel': 'esriSpatialRelIntersects',
        'distance': '',
        'units': 'esriSRUnit_Foot',
        'relationParam': '',
        'outFields': '*',
        'returnGeometry': 'true',
        'maxAllowableOffset': '',
        'geometryPrecision': '',
        'outSR': '',
        'havingClause': '',
        'gdbVersion': '',
        'historicMoment': '',
        'returnDistinctValues': 'false',
        'returnIdsOnly': 'false',
        'returnCountOnly': 'false',
        'returnExtentOnly': 'false',
        'orderByFields': '',
        'groupByFieldsForStatistics': '',
        'outStatistics': '',
        'returnZ': 'false',
        'returnM': 'false',
        'multipatchOption': 'xyFootprint',
        'resultOffset': '',
        'resultRecordCount': '',
        'returnTrueCurves': 'false',
        'returnExceededLimitFeatures': 'false',
        'quantizationParameters': '',
        'returnCentroid': 'false',
        'timeReferenceUnknownClient': 'false',
        'maxRecordCountFactor': '',
        'sqlFormat': 'none',
        'resultType': '',
        'featureEncoding': 'esriDefault',
        'datumTransformation': '',
        'f': 'geojson',
      },
    ).toString();
  }

  static String getEsriDwellings(String? entranceGlobalId) {
    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/2/query',
      queryParameters: {
        'where': 'DwlEntGlobalID =\'$entranceGlobalId\'',
        'objectIds': '',
        'time': '',
        'geometry': '',
        'geometryType': 'esriGeometryEnvelope',
        'inSR': '',
        'defaultSR': '',
        'spatialRel': 'esriSpatialRelIntersects',
        'distance': '',
        'units': 'esriSRUnit_Foot',
        'relationParam': '',
        'outFields': '*',
        'returnGeometry': 'true',
        'maxAllowableOffset': '',
        'geometryPrecision': '',
        'outSR': '',
        'havingClause': '',
        'gdbVersion': '',
        'historicMoment': '',
        'returnDistinctValues': 'false',
        'returnIdsOnly': 'false',
        'returnCountOnly': 'false',
        'returnExtentOnly': 'false',
        'orderByFields': '',
        'groupByFieldsForStatistics': '',
        'outStatistics': '',
        'returnZ': 'false',
        'returnM': 'false',
        'multipatchOption': 'xyFootprint',
        'resultOffset': '',
        'resultRecordCount': '',
        'returnTrueCurves': 'false',
        'returnCentroid': 'false',
        'timeReferenceUnknownClient': 'false',
        'maxRecordCountFactor': '',
        'sqlFormat': 'none',
        'resultType': '',
        'featureEncoding': 'esriDefault',
        'datumTransformation': '',
        'f': 'geojson',
      },
    ).toString();
  }

  static String addEsriFeauture(EntityType entityType) {
    int layerId = EsriConfig.entranceLayerId;

    switch (entityType) {
      case EntityType.building:
        layerId = EsriConfig.buildingLayerId;
        break;

      case EntityType.entrance:
        layerId = EsriConfig.entranceLayerId;
        break;

      case EntityType.dwelling:
        layerId = EsriConfig.dwellingLayerId;
        break;
    }

    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/$layerId/addFeatures',
    ).toString();
  }

  static String updateEsriFeauture(EntityType entityType) {
    int layerId = EsriConfig.entranceLayerId;

    switch (entityType) {
      case EntityType.building:
        layerId = EsriConfig.buildingLayerId;
        break;

      case EntityType.entrance:
        layerId = EsriConfig.entranceLayerId;
        break;

      case EntityType.dwelling:
        layerId = EsriConfig.dwellingLayerId;
        break;
    }

    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/$layerId/updateFeatures',
    ).toString();
  }

  static String deleteEsriFeauture(EntityType entityType) {
    int layerId = EsriConfig.entranceLayerId;

    switch (entityType) {
      case EntityType.building:
        layerId = EsriConfig.buildingLayerId;
        break;

      case EntityType.entrance:
        layerId = EsriConfig.entranceLayerId;
        break;

      case EntityType.dwelling:
        layerId = EsriConfig.dwellingLayerId;
        break;
    }

    return Uri(
      scheme: esriBaseUri.scheme,
      host: esriBaseUri.host,
      path: '${esriBaseUri.path}/$layerId/deleteFeatures',
    ).toString();
  }
}
