// core/config/environment_config.dart

import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/core/enums/app_environment.dart';

class EnvironmentConfig {
  static const AppEnvironment environment = AppEnvironment.production;

  static String get apiBaseUrl {
    return AppConfig.apiBaseUrl;
  }
}
