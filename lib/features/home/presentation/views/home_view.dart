import 'package:flutter/material.dart';
import 'package:asrdb/core/constants/app_config.dart';
import 'package:asrdb/features/home/presentation/layout/home_mobile.dart';
import 'package:asrdb/features/home/presentation/layout/home_tablet.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppConfig.tabletBreakpoint) {
          return const HomeMobile(); // Mobile layout
        } else {
          return const HomeTablet(); // Tablet layout
        }
      },
    ));
  }
}
