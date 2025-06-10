import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/core/services/output_logs_service.dart';

class OutputLogRepository {
  final OutputLogsService outputLogsService;

  OutputLogRepository(this.outputLogsService);

  Future<ProcessOutputLogResponse> getOutputLogs(
      String buildingGlobalId) async {
    return await outputLogsService.getOutputLogs(buildingGlobalId);
  }
}
