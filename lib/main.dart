import 'dart:io';

import 'package:asrdb/core/api/note_api.dart';
import 'package:asrdb/core/api/schema_api.dart';
import 'package:asrdb/core/api/street_api.dart';
import 'package:asrdb/core/db/street_database.dart';
import 'package:asrdb/core/field_work_status_cubit.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/core/services/legend_service.dart';
import 'package:asrdb/core/services/note_service.dart';
import 'package:asrdb/core/services/schema_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/street_service.dart';
import 'package:asrdb/core/services/tile_index_service.dart';
import 'package:asrdb/core/services/user_service.dart';
import 'package:asrdb/data/repositories/download_repository.dart';
import 'package:asrdb/features/cubit/tile_cubit.dart';
import 'package:asrdb/features/home/building_module.dart';
import 'package:asrdb/features/home/cubit/building_geometry_cubit.dart';
import 'package:asrdb/features/home/cubit/entrance_geometry_cubit.dart';
import 'package:asrdb/features/home/cubit/geometry_editor_cubit.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/dwelling_module.dart';
import 'package:asrdb/features/home/entrance_module.dart';
import 'package:asrdb/features/home/municipality_module.dart';
import 'package:asrdb/features/home/output_logs_module.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:asrdb/features/home/presentation/loading_cubit.dart';
import 'package:asrdb/features/home/presentation/municipality_cubit.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:asrdb/features/offline/domain/download_usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/features/auth/auth_module.dart';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';
import 'package:asrdb/features/auth/presentation/lang_cubit.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'routing/route_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:asrdb/core/themes/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final sl = GetIt.instance; // Service locator instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FMTCObjectBoxBackend().initialise();
  await FMTCStore('mapStore').manage.create();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await dotenv.load();
  // await LocalStorageService().init();

  sl.registerLazySingleton<StreetApi>(() => StreetApi());

  final legendService = LegendService();
  final streetService = StreetService(sl<StreetApi>());
  await legendService.loadLegendConfigs();
  await Hive.initFlutter();
  await StreetDatabase.database;

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String offlineMapsPath = '${appDocDir.path}/offline_maps/';

  final tileIndex = TileIndexService(offlineMapsPath);
  await tileIndex.preloadTiles();

  sl.registerSingleton<DatabaseService>(DatabaseService());

  sl.registerSingleton<LegendService>(legendService);
  sl.registerSingleton<StreetService>(streetService);

  // Register API
  sl.registerLazySingleton<SchemaApi>(() => SchemaApi());

  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<StorageRepository>(
      () => StorageRepository(sl<StorageService>()));

  // Register SchemaService as singleton
  sl.registerSingleton<SchemaService>(
    SchemaService(sl<SchemaApi>()),
  );
  sl.registerLazySingleton<NoteApi>(() => NoteApi());
  sl.registerSingleton<UserService>(UserService());

  sl.registerLazySingleton<NoteService>(() => NoteService(sl<NoteApi>()));

  sl.registerLazySingleton<AttributesCubit>(() => AttributesCubit(
      sl<EntranceUseCases>(), sl<BuildingUseCases>(), sl<DwellingUseCases>()));

  sl.registerLazySingleton<DownloadRepository>(
      () => DownloadRepository(sl<DatabaseService>()));

  sl.registerLazySingleton<DownloadUsecases>(
      () => DownloadUsecases(sl<DownloadRepository>()));

  // Initialize schemas immediately
  await sl<SchemaService>().initialize();
  sl.registerFactory<TileCubit>(() => TileCubit());

  sl.registerFactory<EntranceGeometryCubit>(() => EntranceGeometryCubit());
  sl.registerFactory<BuildingGeometryCubit>(() => BuildingGeometryCubit());
  sl.registerFactory<GeometryEditorCubit>(() => GeometryEditorCubit(
      entranceCubit: sl<EntranceGeometryCubit>(),
      buildingCubit: sl<BuildingGeometryCubit>()));

  initAuthModule(sl);
  initEntranceModule(sl);
  initBuildingModule(sl);
  initDwellingModule(sl);
  initOutputLogsModule(sl);
  initMunicipalityModule(sl);

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
        BlocProvider(create: (context) => sl<DwellingCubit>()),
        BlocProvider(create: (context) => sl<MunicipalityCubit>()),
        BlocProvider(create: (context) => sl<OutputLogsCubit>()),
        BlocProvider(create: (context) => sl<TileCubit>()),
        BlocProvider(create: (context) => sl<EntranceGeometryCubit>()),
        BlocProvider(create: (context) => sl<BuildingGeometryCubit>()),
        BlocProvider(create: (context) => sl<GeometryEditorCubit>()),
        BlocProvider(create: (_) => LoadingCubit()),
        BlocProvider(create: (context) => LangCubit()),
        BlocProvider(
            create: (context) =>
                FieldWorkCubit(wsUri: Uri.parse(AppConfig.fieldWorkWebSocket))),
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
