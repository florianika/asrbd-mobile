
class AppConfig {
  static const String appName = 'ASRBD';
  static const String version = '1.0.0';

  // API configurations
  static const String apiBaseUrl = 'http://51.107.11.117:9090';
  static const String fieldWorkWebSocket = 'ws://51.107.11.117:9090/qms/fieldwork/is-active';
  static const int apiTimeout = 60; // seconds

  // App theme configuration (optional)
  static const bool useDarkTheme = false;
  static const double defaultFontSize = 14.0;
}
