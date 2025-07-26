import 'package:asrdb/core/api/entrance_api.dart';
import 'package:asrdb/core/services/entrance_service.dart';
import 'package:asrdb/features/home/data/entrance_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/entrance_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:asrdb/features/home/presentation/entrance_cubit.dart';
import 'package:get_it/get_it.dart';

void initEntranceModule(GetIt slEntrance) {
  // final slEntrance = GetIt.instance; // Service locator instance
  // Register API client
  slEntrance.registerLazySingleton<EntranceApi>(() => EntranceApi());

  // Register AuthService
  slEntrance.registerLazySingleton<EntranceService>(
      () => EntranceService(slEntrance<EntranceApi>()));

  // Register repository
  slEntrance.registerLazySingleton<EntranceRepository>(
      () => EntranceRepository(slEntrance<EntranceService>()));

  // Register use cases
  slEntrance.registerLazySingleton<EntranceUseCases>(
      () => EntranceUseCases(slEntrance<EntranceRepository>()));

  // Register Cubit (State Management)
  slEntrance.registerFactory<EntranceCubit>(() => EntranceCubit(
        slEntrance<EntranceUseCases>(),
        slEntrance<CheckUseCases>(),
        slEntrance<AttributesCubit>(),
        slEntrance<DwellingCubit>(),
      ));
}
