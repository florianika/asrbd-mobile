import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'ASRBD';
  static const String version = '1.0.0';

  static const double tabletBreakpoint = 600.0;

  static const String defaultLanguage = 'sq';

  // API configurations
  static String apiBaseUrl = dotenv.env['API_URL'] ?? "";
  static String fieldWorkWebSocket = dotenv.env['API_SOCKET_URL'] ?? "";
  static const int apiTimeout = 300; // seconds


  static String esriUriPath = dotenv.env['ESRI_API_PATH'] ?? "";
  static String esriUriScheme = dotenv.env['ESRI_API_SCHEME'] ?? "";
  static String esriUriHost = dotenv.env['ESRI_API_HOST'] ?? "";

  static String esriMunicipalityUriPath = dotenv.env['ESRI_MUNICIPALITY_PATH'] ?? "";
  static String esriMunicipalityUriScheme =
      dotenv.env['ESRI_MUNICIPALITY_SCHEME'] ?? "";
  static String esriMunicipalityUriHost =
      dotenv.env['ESRI_MUNICIPALITY_HOST'] ?? "";

  static const double defaultLatitude = 41.3351224;
  static const double defaultLongitude = 19.8276994;
  // static const double scale = 72000;

  //maximum number of buildings that can be downloaded for offline use
  static const int maxNoBuildings = 50;

  //minimum zoom level for the map in order that can be downloaded for offline use
  static const double minZoomDownload = 16.0;

  //initial zoom level for the map
  static const double initZoom = 19.0;

  //minimum zoom level for the map in order to load entrances
  static const double entranceMinZoom = 20.5;

  //minimum zoom level for the map in order to load buildings
  static const double buildingMinZoom = 17.0;

  //esri layer IDs
  static const int entranceLayerId = 0;
  static const int buildingLayerId = 1;
  static const int dwellingLayerId = 2;
  static const int streetLayerId = 3;
  static const int municipalityLayerId = 7;
}
