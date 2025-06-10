import 'package:asrdb/core/api/dwelling_api.dart';
import 'package:asrdb/core/services/dwelling_service.dart';
import 'package:asrdb/features/home/data/dwelling_repository.dart';
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
  slDwelling.registerLazySingleton<DwellingRepository>(
      () => DwellingRepository(slDwelling<DwellingService>()));

  // Register use cases
  slDwelling.registerLazySingleton<DwellingUseCases>(
      () => DwellingUseCases(slDwelling<DwellingRepository>()));

  // Register Cubit (State Management)
  slDwelling.registerFactory<DwellingCubit>(() => DwellingCubit(
        slDwelling<DwellingUseCases>(),
        slDwelling<AttributesCubit>(),
      ));
}
