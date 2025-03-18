import 'package:flutter_dotenv/flutter_dotenv.dart';

class EsriConfig {
  static const String redirectUrl = "my-ags-flutter-app://auth";
  static String portalUrl = dotenv.env['ESRI_PORTAL_URL'] ?? "";
  static String clientId = dotenv.env['ESRI_CLIENT_ID'] ?? "";

  static const double defaultLatitude = 41.3351224;
  static const double defaultLongitude = 19.8276994;
  static const double scale = 72000;

  static const int entranceLayerId = 0;
  static const int buildingLayerId = 1;
  static const int dwellingLayerId = 2;

  static const String baseMapItemId = "32a59baad2da483887e467330041b113";
  static const String dataItemId = "64658d3e33d74e6ab47fc0725f1e93af";
}
