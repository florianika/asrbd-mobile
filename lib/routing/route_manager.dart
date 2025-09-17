import 'package:asrdb/features/home/presentation/views/view_map.dart';
import 'package:asrdb/features/offline/presentation/views/offline_map.dart';
import 'package:asrdb/features/offline/presentation/views/offline_map_list.dart';
import 'package:asrdb/features/settings/presentation/views/settings_view.dart';
import 'package:asrdb/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/features/auth/presentation/views/login_view.dart';

class 
RouteManager {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';
  static const String downloadMapRoute = '/download-map';
  static const String downloadedMapList = '/download-map-list';
  static const String settingsRoute = '/settings';

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

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found!')),
      ),
    );
  }
}
