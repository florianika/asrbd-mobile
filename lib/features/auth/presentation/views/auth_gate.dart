import 'dart:convert';
import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/field_work_status_cubit.dart';
import 'package:asrdb/core/services/auth_service.dart';
import 'package:asrdb/core/services/street_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/main.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';

/// AuthGate decides whether to route to login or home map
/// based on the stored access token's expiration time.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final userService = sl<UserService>();

  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    try {
      final isValid = await _hasValidToken();

      if (!mounted) return;

      if (isValid) {
        // Initialize services required by the map view
        await _initializeServices();
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(RouteManager.homeRoute);
      } else {
        Navigator.of(context).pushReplacementNamed(RouteManager.loginRoute);
      }
    } catch (e) {
      debugPrint('AuthGate error: $e');
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RouteManager.loginRoute);
    }
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize user service to load user info
      final user = await userService.initialize();

      if (user != null) {
        // Initialize street service with user's municipality
        await sl<StreetService>().clearAllStreets();
        final streets = await sl<StreetService>().getStreets(user.municipality);
        sl<StreetService>().saveStreets(streets);
      }

      // Reconnect WebSocket with fresh token after services are initialized
      if (mounted) {
        context.read<FieldWorkCubit>().reconnectWithFreshToken();
      }
    } catch (e) {
      // Log error but don't block navigation - map might still work partially
      debugPrint('Error initializing services in AuthGate: $e');
    }
  }

  Future<bool> _hasValidToken() async {
    final storage = StorageService();
    final token = await storage.getString(key: StorageKeys.accessToken);

    if (token == null || token.isEmpty) {
      return false;
    }

    // Attempt to parse JWT and check exp claim
    try {
      // JWT format: header.payload.signature (Base64URL)
      final parts = token.split('.');
      if (parts.length != 3) return true; // Non-JWT tokens treated as valid

      final payload = parts[1];
      // Fix Base64URL padding
      String normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }
      final decoded = utf8.decode(base64.decode(normalized));
      final Map<String, dynamic> json = jsonDecode(decoded);

      final exp = json['exp'];
      if (exp is int) {
        final isValid = DateTime.now()
            .isBefore(DateTime.fromMillisecondsSinceEpoch(exp * 1000));

        // If token is expired, try to refresh it
        if (!isValid) {
          debugPrint('Access token expired, attempting refresh...');
          try {
            final authApi = AuthApi();
            final authService = AuthService(authApi);
            await authService.refreshToken();
            debugPrint('Token refresh successful');
            return true; // Token refreshed successfully
          } catch (e) {
            debugPrint('Token refresh failed: $e');
            return false; // Refresh failed, need to login
          }
        }

        return isValid;
      }

      // If no exp claim, assume valid
      return true;
    } catch (_) {
      // On parsing errors, assume token is invalid to be safe
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
