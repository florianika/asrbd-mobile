import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/main.dart';

/// Service for handling navigation from non-UI contexts (e.g., interceptors)
class NavigationService {
  /// Navigate to the login screen
  /// This can be called from anywhere, including API interceptors
  static void navigateToLogin() {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      // Remove all previous routes and navigate to login
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteManager.loginRoute,
        (route) => false,
      );
    }
  }
}
