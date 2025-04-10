import 'package:asrdb/features/home/presentation/views/view_map.dart';
import 'package:asrdb/features/offline/presentation/views/open_maps_test.dart';
import 'package:asrdb/features/offline/presentation/views/open_maps_test_dowload.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/features/auth/presentation/views/login_view.dart';

class RouteManager {
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const ViewMap());
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
