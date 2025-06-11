import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/widgets/loading_indicator.dart';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';
import 'package:asrdb/features/auth/presentation/lang_cubit.dart';
import 'package:asrdb/features/auth/presentation/widget/language_selector.dart';
import 'package:asrdb/features/auth/presentation/widget/password_field.dart';
import 'package:asrdb/features/auth/presentation/widget/username_field.dart';
import 'package:asrdb/localization/keys.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginMobile extends StatefulWidget {
  LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }

  @override
  void initState() {
    super.initState();

    emailController.text = dotenv.env['TEST_USERNAME'] ?? "";
    passwordController.text = dotenv.env['TEST_PASSWORD'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    void onLanguageSelected(String languageCode) {
      context.read<LangCubit>().changeLanguage(languageCode);
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushReplacementNamed(
                          context, RouteManager.homeRoute);
                    } else if (state is AuthError) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return LoadingIndicator(
                      isLoading: state is AuthLoading,
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Centered text at the top
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  AppConfig.appName,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              // Username Field
                              UsernameField(
                                controller: emailController,
                                validator: (value) => value!.isEmpty
                                    ? AppLocalizations.of(context)
                                        .translate(Keys.enterMail)
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              // Password Field
                              PasswordField(
                                controller: passwordController,
                                validator: (value) => value!.isEmpty
                                    ? AppLocalizations.of(context)
                                        .translate(Keys.enterPassword)
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () => _onLogin(context),
                                  child: Text(AppLocalizations.of(context)
                                      .translate(Keys.login)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: LanguageSelector(
                onLanguageSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
