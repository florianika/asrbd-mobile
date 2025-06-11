import 'package:asrdb/core/api/schema_api.dart';
import 'package:asrdb/core/api/street_api.dart';
import 'package:asrdb/core/db/street_database.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/note_service.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/services/street_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/features/home/building_module.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/dwelling_module.dart';
import 'package:asrdb/features/home/entrance_module.dart';
import 'package:asrdb/features/home/output_logs_module.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/new_geometry_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final sl = GetIt.instance; // Service locator instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await dotenv.load();
  await LocalStorageService().init();

  sl.registerLazySingleton<StreetApi>(() => StreetApi());

  final legendService = LegendService();
  final streetService = StreetService(sl<StreetApi>());
  // final localDbService = LocalDatabaseService();
  await legendService.loadLegendConfigs();

  await StreetDatabase.database;

  sl.registerSingleton<LegendService>(legendService);
  sl.registerSingleton<StreetService>(streetService);
  // sl.registerSingleton<LocalDatabaseService>(localDbService);

  // Register API
  sl.registerLazySingleton<SchemaApi>(() => SchemaApi());

  // Register SchemaService as singleton
  sl.registerSingleton<SchemaService>(
    SchemaService(sl<SchemaApi>()),
  );
   sl.registerLazySingleton<NoteApi>(() => NoteApi());
  sl.registerSingleton<UserService>(UserService());
    sl.registerLazySingleton<NoteService>(() => NoteService(sl<NoteApi>()));

  sl.registerLazySingleton<AttributesCubit>(() => AttributesCubit(
      sl<EntranceUseCases>(), sl<BuildingUseCases>(), sl<DwellingUseCases>()));

  // Initialize schemas immediately
  await sl<SchemaService>().initialize();

  sl.registerFactory<NewGeometryCubit>(() => NewGeometryCubit());

  initAuthModule(sl);
  initEntranceModule(sl);
  initBuildingModule(sl);
  initDwellingModule(sl);
  initOutputLogsModule(sl);

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
        BlocProvider(create: (context) => sl<AttributesCubit>()),
        BlocProvider(create: (context) => sl<NewGeometryCubit>()),
        BlocProvider(create: (context) => sl<DwellingCubit>()),
        BlocProvider(create: (context) => sl<OutputLogsCubit>()),
        BlocProvider(create: (context) => LangCubit()),
      ],
      child: BlocBuilder<LangCubit, String>(
        builder: (context, langCode) {
          return MaterialApp(
            navigatorKey: rootNavigatorKey,
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
