import 'package:asrdb/core/config/esri_config.dart';

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/user/profile';

  static String esriEntrance = Uri(
    scheme: 'https',
    host: "salstatstaging.tddev.it",
    path: '/arcgis/rest/services/SALSTAT/asrbd/FeatureServer/0/query',
    queryParameters: {
      'where': '1=1',
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
      'outFields': EsriConfig.entranceProperties.join(','),
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
      'token': 'PlxKQBrHT_kay-oB4GGujJ0WWzT6HeuMx9mOygPeUnaKqV4XNcntNAKeD9lBrE-hsu8KJxc_u3vz2ov8xrN-VJZQVFEFZmcikhnw2I72evZX-xQHRkNdChfr4rQNKhEfnwIhsokXEqK4Z5jfBW_vi5FZAJVaS3dKAk7hB9wRvyY.',
    },
  ).toString();
}
