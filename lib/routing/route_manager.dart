import 'package:asrdb/features/auth/presentation/forgot_password_cubit.dart';
import 'package:asrdb/features/auth/presentation/views/auth_gate.dart';
import 'package:asrdb/features/auth/presentation/views/forgot_password_view.dart';
import 'package:asrdb/features/auth/presentation/views/otp_view.dart';
import 'package:asrdb/features/home/presentation/views/view_map.dart';
import 'package:asrdb/features/offline/presentation/views/offline_map.dart';
import 'package:asrdb/features/offline/presentation/views/offline_map_list.dart';
import 'package:asrdb/features/settings/presentation/views/settings_view.dart';
import 'package:asrdb/features/profile/presentation/views/profile_view.dart';
import 'package:asrdb/features/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/features/auth/presentation/views/login_view.dart';
import 'package:asrdb/features/auth/domain/auth_usecases.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/main.dart';

class RouteManager {
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String profileRoute = '/profile';
  static const String downloadMapRoute = '/download-map';
  static const String downloadedMapList = '/download-map-list';
  static const String settingsRoute = '/settings';
  static const String otpRoute = '/optRoute';
  static const String testRoute = '/test';
  static const String authGateRoute = '/auth-gate';
  static const String forgotPasswordRoute = '/forgot-password';

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
        return MaterialPageRoute(builder: (_) => OtpView(userId: userId));

      case testRoute:
        return MaterialPageRoute(
            builder: (_) => const TiranaImageOverlayWidget());

      case authGateRoute:
        return MaterialPageRoute(builder: (_) => AuthGate());

      case forgotPasswordRoute:
        final email = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ForgotPasswordCubit(sl<AuthUseCases>()),
                  child: ForgotPasswordView(initialEmail: email),
                ));

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
