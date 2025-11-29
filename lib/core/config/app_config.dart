import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String appName = 'ASRBD';
  static const String version = '1.0.0';

  static const String defaultLanguage = 'sq';

  static const double maxZoom = 21.0;

  // API configurations
  static String apiBaseUrl = dotenv.env['API_URL'] ?? "";
  static String fieldWorkWebSocket = dotenv.env['API_SOCKET_URL'] ?? "";
  static const int apiTimeout = 300; // seconds

  static String esriUriPath = dotenv.env['ESRI_API_PATH'] ?? "";
  static String esriUriScheme = dotenv.env['ESRI_API_SCHEME'] ?? "";
  static String esriUriHost = dotenv.env['ESRI_API_HOST'] ?? "";

  static String esriMunicipalityUriPath =
      dotenv.env['ESRI_MUNICIPALITY_PATH'] ?? "";
  static String esriMunicipalityUriScheme =
      dotenv.env['ESRI_MUNICIPALITY_SCHEME'] ?? "";
  static String esriMunicipalityUriHost =
      dotenv.env['ESRI_MUNICIPALITY_HOST'] ?? "";

  //maximum number of buildings that can be downloaded for offline use
  static const int maxNoBuildings = 50;

  //minimum zoom level for the map in order that can be downloaded for offline use
  static const double minZoomDownload = 16.0;

  //initial zoom level for the map
  static const double initZoom = 19.0;
  static const double initZoomAsig = 7.0;

  //minimum zoom level for the map in order to load entrances
  static const double entranceMinZoom = 19.5;

  //minimum zoom level for the map in order to load buildings
  static const double buildingMinZoom = 16.0;

  //maximum distance in meters for entrance validation from building
  static const double maxEntranceDistanceFromBuilding = 2.0;

  //esri layer IDs
  static const int entranceLayerId = 0;
  static const int buildingLayerId = 1;
  static const int dwellingLayerId = 2;
  static const int streetLayerId = 3;
  static const int municipalityLayerId = 7;

  //map store name to be used by FMTCStore to use basemap.
  static const String mapTerrainStoreName = "mapStoreTerrain";
  static const String mapEsriSatelliteStoreName = "mapStoreEsriSatellite";
  static const String mapAsigSatellite2025StoreName = "mapStoreAsigSatellite2025";

  static const String basemapEsriSatelliteUrl =
      "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";
      
    static const String basemapAsigSatellite2025Url =
      "https://di-albania-satellite1.img.arcgis.com/arcgis/rest/services/rgb/Albania_2025_L1/MapServer/WMTS/tile/1.0.0/rgb_Albania_2025_L1/default/default028mm/{z}/{y}/{x}";
  static const String basemapTerrainUrl =
      "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

  //this agent is used while consumin open street map. do not remove it in order to not get blocked by open street map
  static const String userAgentPackageName = "com.asrdb.al";
}
