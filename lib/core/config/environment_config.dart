// core/config/environment_config.dart

import 'package:asrdb/core/enums/app_environment.dart';

class EnvironmentConfig {
  static const AppEnvironment environment = AppEnvironment.production;

  static String get apiBaseUrl {
    switch (environment) {
      case AppEnvironment.production:
        return 'https://api.prod.yourapp.com';
      case AppEnvironment.dev:
        return 'https://api.staging.yourapp.com';
      default:
        return 'https://api.dev.yourapp.com'; // Development URL
    }
  }
}
