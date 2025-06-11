import 'package:asrdb/core/api/building_api.dart';
import 'package:asrdb/core/services/building_service.dart';
import 'package:asrdb/features/home/data/building_repository.dart';
import 'package:asrdb/features/home/domain/building_usecases.dart';
import 'package:asrdb/features/home/presentation/attributes_cubit.dart';
import 'package:asrdb/features/home/presentation/building_cubit.dart';
import 'package:asrdb/features/home/presentation/dwelling_cubit.dart';
import 'package:get_it/get_it.dart';

void initBuildingModule(GetIt slBuilding) {
  // final slEntrance = GetIt.instance; // Service locator instance
  // Register API client
  slBuilding.registerLazySingleton<BuildingApi>(() => BuildingApi());

  // Register AuthService
  slBuilding.registerLazySingleton<BuildingService>(
      () => BuildingService(slBuilding<BuildingApi>()));

  // Register repository
  slBuilding.registerLazySingleton<BuildingRepository>(
      () => BuildingRepository(slBuilding<BuildingService>()));

  // Register use cases
  slBuilding.registerLazySingleton<BuildingUseCases>(
      () => BuildingUseCases(slBuilding<BuildingRepository>()));

  // Register Cubit (State Management)
  slBuilding.registerFactory<BuildingCubit>(() => BuildingCubit(
        slBuilding<BuildingUseCases>(),
        slBuilding<AttributesCubit>(),
        slBuilding<DwellingCubit>(),
      ));
}
