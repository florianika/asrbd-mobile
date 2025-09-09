import 'package:flutter/material.dart';
import 'package:asrdb/features/auth/presentation/layout/login_tablet.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return const LoginTablet();
      },
    ));
  }
}
