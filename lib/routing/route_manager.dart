import 'package:asrdb/features/auth/presentation/views/otp_view.dart';
import 'package:asrdb/features/home/presentation/views/view_map.dart';
import 'package:asrdb/features/offline/presentation/views/offline_map.dart';
import 'package:asrdb/features/offline/presentation/views/offline_map_list.dart';
import 'package:asrdb/features/settings/presentation/views/settings_view.dart';
import 'package:asrdb/features/profile/presentation/views/profile_view.dart';
import 'package:asrdb/features/test.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/features/auth/presentation/views/login_view.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';

class RouteManager {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';
  static const String downloadMapRoute = '/download-map';
  static const String downloadedMapList = '/download-map-list';
  static const String settingsRoute = '/settings';
  static const String otpRoute = '/optRoute';
  static const String testRoute = '/test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case homeRoute:
        return MaterialPageRoute(builder: (_) => const ViewMap());

      case downloadMapRoute:
        return MaterialPageRoute(builder: (_) => const OfflineMap());

      case downloadedMapList:
        return MaterialPageRoute(builder: (_) => DownloadedMapsViewer());

      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsView());

      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileView());

      case otpRoute:
        final userId = settings.arguments as String;
        return MaterialPageRoute( builder: (_) => OtpView(userId: userId));

      case testRoute:
        return MaterialPageRoute(
            builder: (_) => const TiranaImageOverlayWidget());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        final localizations = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(localizations.translate(Keys.error))),
          body: Center(child: Text(localizations.translate(Keys.pageNotFound))),
        );
      },
    );
  }
}
