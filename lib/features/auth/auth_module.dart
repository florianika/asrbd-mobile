import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/services/auth_service.dart';
import 'package:asrdb/features/auth/data/auth_repository.dart';
import 'package:asrdb/features/auth/domain/auth_usecases.dart';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';

void initAuthModule(GetIt sl) {
  // final sl = GetIt.instance; // Service locator instance
  // Register API client
  sl.registerLazySingleton<AuthApi>(() => AuthApi());

  // Register AuthService
  sl.registerLazySingleton<AuthService>(() => AuthService(sl<AuthApi>()));

  // Register repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(sl<AuthService>()));

  // Register use cases
  sl.registerLazySingleton<AuthUseCases>(
      () => AuthUseCases(sl<AuthRepository>(), sl<StorageRepository>()));

  // Register Cubit (State Management)
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthUseCases>()));
}
