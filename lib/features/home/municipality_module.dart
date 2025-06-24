import 'package:asrdb/core/api/municipality_api.dart';
import 'package:asrdb/core/services/municipality_service.dart';
import 'package:asrdb/features/home/data/municipality_repository.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/domain/municipality_usecases.dart';
import 'package:asrdb/features/home/presentation/municipality_cubit.dart';
import 'package:get_it/get_it.dart';

void initMunicipalityModule(GetIt slMunicipality) {
  slMunicipality
      .registerLazySingleton<MunicipalityApi>(() => MunicipalityApi());
  slMunicipality.registerLazySingleton<MunicipalityService>(
      () => MunicipalityService(slMunicipality<MunicipalityApi>()));

  // Register repository
  slMunicipality.registerLazySingleton<MunicipalityRepository>(
      () => MunicipalityRepository(slMunicipality<MunicipalityService>()));

  // Register use cases
  slMunicipality.registerLazySingleton<MunicipalityUseCases>(() =>
      MunicipalityUseCases(slMunicipality<MunicipalityRepository>(),
          slMunicipality<StorageRepository>()));

  // Register Cubit (State Management)
  slMunicipality.registerFactory<MunicipalityCubit>(
      () => MunicipalityCubit(slMunicipality<MunicipalityUseCases>()));
}
