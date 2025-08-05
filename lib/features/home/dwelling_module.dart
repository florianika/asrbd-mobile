import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/services/database_service.dart';
import 'package:asrdb/core/services/dwelling_service.dart';
import 'package:asrdb/data/repositories/dwelling_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/dwelling_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:get_it/get_it.dart';

void initDwellingModule(GetIt slDwelling) {
  // final slEntrance = GetIt.instance; // Service locator instance
  // Register API client
  slDwelling.registerLazySingleton<DwellingApi>(() => DwellingApi());

  // Register AuthService
  slDwelling.registerLazySingleton<DwellingService>(
      () => DwellingService(slDwelling<DwellingApi>()));

  // Register repository
  slDwelling.registerLazySingleton<DwellingRepository>(() => DwellingRepository(
      slDwelling<DatabaseService>(), slDwelling<DwellingService>()));

  // Register use cases
  slDwelling.registerLazySingleton<DwellingUseCases>(() => DwellingUseCases(
      slDwelling<DwellingRepository>(), slDwelling<CheckUseCases>()));

  // Register Cubit (State Management)
  slDwelling.registerFactory<DwellingCubit>(() => DwellingCubit(
        slDwelling<DwellingUseCases>(),
        slDwelling<AttributesCubit>(),
      ));
}
