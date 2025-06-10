import 'package:asrdb/core/api/check_api.dart';
import 'package:asrdb/core/api/output_logs_api.dart';
import 'package:asrdb/core/services/check_service.dart';
import 'package:asrdb/core/services/output_logs_service.dart';
import 'package:asrdb/features/home/data/check_repository.dart';
import 'package:asrdb/features/home/data/output_log_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/output_logs_usecases.dart';
import 'package:asrdb/features/home/presentation/output_logs_cubit.dart';
import 'package:get_it/get_it.dart';

void initOutputLogsModule(GetIt slLogs) {
  // final slEntrance = GetIt.instance; // Service locator instance
  // Register API client
  slLogs.registerLazySingleton<OutputLogsApi>(() => OutputLogsApi());
  slLogs.registerLazySingleton<CheckApi>(() => CheckApi());

  // Register AuthService
  slLogs.registerLazySingleton<OutputLogsService>(
      () => OutputLogsService(slLogs<OutputLogsApi>()));

  slLogs.registerLazySingleton<CheckService>(
      () => CheckService(slLogs<CheckApi>()));

  // Register repository
  slLogs.registerLazySingleton<OutputLogRepository>(
      () => OutputLogRepository(slLogs<OutputLogsService>()));

  slLogs.registerLazySingleton<CheckRepository>(
      () => CheckRepository(slLogs<CheckService>()));

  // Register use cases
  slLogs.registerLazySingleton<OuputLogsUseCases>(
      () => OuputLogsUseCases(slLogs<OutputLogRepository>()));

  slLogs.registerLazySingleton<CheckUseCases>(
      () => CheckUseCases(slLogs<CheckRepository>()));

  // Register Cubit (State Management)
  slLogs.registerFactory<OutputLogsCubit>(() =>
      OutputLogsCubit(slLogs<OuputLogsUseCases>(), slLogs<CheckUseCases>()));
}
