import 'package:asrdb/features/offline/presentation/views/generate_offline_map.dart';
import 'package:asrdb/features/offline/presentation/views/load_offline_map.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/features/auth/presentation/views/login_view.dart';
import 'package:asrdb/features/home/presentation/views/home_view.dart';

class RouteManager {
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const GenerateOfflineMap());
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
