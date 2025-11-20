import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/main.dart';
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
import 'package:url_launcher/url_launcher.dart';

class LoginTablet extends StatefulWidget {
  const LoginTablet({super.key});

  @override
  State<LoginTablet> createState() => _LoginTabletState();
}

class _LoginTabletState extends State<LoginTablet> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userService = sl<UserService>();

  void _onLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }

  void showOfflineLoginWarning(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        const primaryColor = Color.fromARGB(255, 58, 64, 90);
        const lightColor = Color.fromARGB(255, 240, 241, 245);
        const borderColor = Color.fromARGB(255, 180, 185, 200);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Warning',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You must login at least one time before using the app offline.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: primaryColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please connect to the internet and login first.',
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onFirstTimeLogin(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final urlString = dotenv.env['FIRST_TIME_LOGIN_URL'];
    
    if (urlString == null || urlString.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.translate(Keys.firstTimeLoginUrlNotConfigured)),
          ),
        );
      }
      return;
    }

    Uri url;
    try {
      url = Uri.parse(urlString);
      if (!url.hasScheme) {
        // If no scheme, assume https
        url = Uri.parse('https://$urlString');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.translate(Keys.invalidUrl).replaceFirst('{url}', urlString),
            ),
          ),
        );
      }
      return;
    }

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.translate(Keys.couldNotLaunchUrl)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.translate(Keys.errorOpeningUrl).replaceFirst('{error}', e.toString()),
            ),
          ),
        );
      }
    }
  }

  Future<void> _onUseOffline(BuildContext context) async {
    if (userService.userInfo == null) {
      // if (mounted) {
      showOfflineLoginWarning(context);
      // }
    } else {
      Navigator.pushReplacementNamed(context, RouteManager.downloadedMapList);
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
                      // Navigate to the next screen on successful login
                      Navigator.pushReplacementNamed(
                        context,
                        RouteManager.otpRoute,
                        arguments: state.userId,
                      );
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
                          width: MediaQuery.of(context).size.width * 0.5,
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
                              // Buttons Row
                              Row(
                                children: [
                                  // Use Offline Button
                                  Expanded(
                                    child: SizedBox(
                                      height: 50.0,
                                      child: OutlinedButton(
                                        onPressed: () => _onUseOffline(context),
                                        child: Text(AppLocalizations.of(context)
                                            .translate(Keys.useOffline)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Login Button
                                  Expanded(
                                    child: SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        onPressed: () => _onLogin(context),
                                        child: Text(AppLocalizations.of(context)
                                            .translate(Keys.login)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // First Time Login Button
                              Center(
                                child: TextButton(
                                  onPressed: () => _onFirstTimeLogin(context),
                                  child: Text(AppLocalizations.of(context)
                                      .translate(Keys.firstTimeLogin)),
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
