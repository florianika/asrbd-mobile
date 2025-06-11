import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/output_logs_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OutputLogsState {}

class OutputLogsInitial extends OutputLogsState {}

class OutputLogsLoading extends OutputLogsState {}

class OutputLogs extends OutputLogsState {
  final ProcessOutputLogResponse validationResult;

  OutputLogs(this.validationResult);
}

class OutputLogsError extends OutputLogsState {
  final String message;
  OutputLogsError(this.message);
}

class OutputLogsCubit extends Cubit<OutputLogsState> {
  final OuputLogsUseCases outputLogsUseCases;
  final CheckUseCases checkUseCases;

  OutputLogsCubit(this.outputLogsUseCases, this.checkUseCases)
      : super(OutputLogsInitial());

  Future<void> checkAutomatic(String buildingGlobalId) async {
    // emit(OutputLogsLoading());
    try {
      await checkUseCases.checkAutomatic(buildingGlobalId);
      emit(
          OutputLogs(await outputLogsUseCases.getOutputLogs(buildingGlobalId)));
    } catch (e) {
      emit(OutputLogsError(e.toString()));
    }
  }

  Future<void> checkBuildings(String buildingGlobalId) async {
    // emit(OutputLogsLoading());
    try {
      await checkUseCases.checkBuildings(buildingGlobalId);
      emit(
          OutputLogs(await outputLogsUseCases.getOutputLogs(buildingGlobalId)));
    } catch (e) {
      emit(OutputLogsError(e.toString()));
    }
  }
}
