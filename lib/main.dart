import 'package:asrdb/features/home/building_module.dart';
import 'package:asrdb/features/home/entrance_module.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/features/auth/auth_module.dart';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';
import 'package:asrdb/features/auth/presentation/lang_cubit.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:get_it/get_it.dart';
import 'core/local_storage/local_storage_service.dart';
import 'routing/route_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:asrdb/core/themes/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sl = GetIt.instance; // Service locator instance
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await LocalStorageService().init();
  initAuthModule(sl);
  initEntranceModule(sl);
  initBuildingModule(sl);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<EntranceCubit>()),
        BlocProvider(create: (context) => sl<BuildingCubit>()),
        BlocProvider(
            create: (context) => LangCubit()), // Provide LangCubit here
      ],
      child: BlocBuilder<LangCubit, String>(
        builder: (context, langCode) {
          return MaterialApp(
            title: AppConfig.appName,
            locale:
                Locale(langCode), // Update locale based on the LangCubit state
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateRoute: RouteManager.generateRoute,
            theme: AppTheme.lightTheme(), // Use the light theme
            darkTheme: AppTheme.darkTheme(), // Use the dark theme
            themeMode: ThemeMode.system,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: RouteManager.loginRoute,
          );
        },
      ),
    );
  }
}
