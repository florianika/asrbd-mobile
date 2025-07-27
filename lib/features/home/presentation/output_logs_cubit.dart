import 'dart:convert';

import 'package:asrdb/core/enums/validation_level.dart';
import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';
import 'package:asrdb/features/home/domain/check_usecases.dart';
import 'package:asrdb/features/home/domain/output_logs_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OutputLogsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OutputLogsInitial extends OutputLogsState {}

class OutputLogsLoading extends OutputLogsState {}

class OutputLogs extends OutputLogsState {
  final ProcessOutputLogResponse validationResult;
  final bool? hasErrorOrWarning;
  final DateTime emittedAt;

  OutputLogs(this.validationResult, this.hasErrorOrWarning)
      : emittedAt = DateTime.now();

  @override
  List<Object?> get props => [validationResult, emittedAt];
}

class OutputLogsTest extends OutputLogsState {
  final String msg;

  OutputLogsTest(this.msg);
}

class OutputBuildingLogs extends OutputLogsState {
  final ProcessOutputLogResponse validationResult;

  OutputBuildingLogs(this.validationResult);
}

class OutputLogsError extends OutputLogsState {
  final String message;
  final int timestamp;
  OutputLogsError(this.message, this.timestamp);
}

class OutputLogsCubit extends Cubit<OutputLogsState> {
  final OuputLogsUseCases outputLogsUseCases;
  final CheckUseCases checkUseCases;
  final StorageRepository storageRepository;

  OutputLogsCubit(
    this.outputLogsUseCases,
    this.checkUseCases,
    this.storageRepository,
  ) : super(OutputLogsInitial());

  Future<void> checkAutomatic(String buildingGlobalId) async {
    try {
      await checkUseCases.checkAutomatic(buildingGlobalId);
      final validationResult =
          await outputLogsUseCases.getOutputLogs(buildingGlobalId);
      ProcessOutputLogResponse response = ProcessOutputLogResponse(
          processOutputLogDto: validationResult.processOutputLogDto);
      bool hasErrorOrWarning = validationResult.processOutputLogDto.any(
        (item) => item.errorLevel == 'error' || item.errorLevel == 'warning',
      );
      await storageRepository.saveString(
        key: buildingGlobalId,
        value: jsonEncode(response.toJson()),
      );
      emit(OutputLogs(validationResult, hasErrorOrWarning));
    } catch (e) {
      emit(
          OutputLogsError(e.toString(), DateTime.now().millisecondsSinceEpoch));
    }
  }

  Future<void> checkBuildings(String buildingGlobalId) async {
    try {
      await checkUseCases.checkBuildings(buildingGlobalId);
      final validationResult =
          await outputLogsUseCases.getOutputLogs(buildingGlobalId);
      ProcessOutputLogResponse response = ProcessOutputLogResponse(
          processOutputLogDto: validationResult.processOutputLogDto);

      bool hasErrorOrWarning = validationResult.processOutputLogDto.any(
        (item) => item.errorLevel == 'ERR' || item.errorLevel == 'WARN' || item.errorLevel == 'MISS' || item.errorLevel == 'OWN',
      );

      await storageRepository.saveString(
        key: buildingGlobalId,
        value: jsonEncode(response.toJson()),
      );
      emit(OutputLogs(validationResult, hasErrorOrWarning));
    } catch (e) {
      emit(
          OutputLogsError(e.toString(), DateTime.now().millisecondsSinceEpoch));
    }
  }

  Future<void> outputLogsBuildings(String buildingGlobalId) async {
    try {
      // emit(OutputLogsLoading());
      final cachedJson =
          await storageRepository.getString(key: buildingGlobalId);

      if (cachedJson != null) {
        var parsed = ProcessOutputLogResponse.fromJson(jsonDecode(cachedJson));
 

        emit(OutputLogs(parsed, null));
      } else {
        final freshData =
            await outputLogsUseCases.getOutputLogs(buildingGlobalId);

      
        await storageRepository.saveString(
          key: buildingGlobalId,
          value: jsonEncode(freshData.toJson()),
        );

        emit(OutputLogs(freshData, null));
      }
    } catch (e) {
      emit(
          OutputLogsError(e.toString(), DateTime.now().millisecondsSinceEpoch));
    }
  }
}
