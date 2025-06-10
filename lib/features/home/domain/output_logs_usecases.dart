import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/features/home/data/output_log_repository.dart';

class OuputLogsUseCases {
  final OutputLogRepository _outputLogsRepository;

  OuputLogsUseCases(this._outputLogsRepository);

  Future<ProcessOutputLogResponse> getOutputLogs(
      String buildingGlobalId) async {
    return await _outputLogsRepository.getOutputLogs(buildingGlobalId);
  }
}
