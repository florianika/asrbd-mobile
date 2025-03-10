import 'package:flutter/material.dart';
import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/features/auth/presentation/layout/login_mobile.dart';
import 'package:asrdb/features/auth/presentation/layout/login_tablet.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppConfig.tabletBreakpoint) {
          return LoginMobile(); // Mobile layout
        } else {
          return LoginTablet(); // Tablet layout
        }
      },
    ));
  }
}
