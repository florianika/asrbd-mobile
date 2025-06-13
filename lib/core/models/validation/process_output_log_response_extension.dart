import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/validation_level.dart';
import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/core/models/validation/validaton_result.dart';

extension ProcessOutputLogResponseExtension on ProcessOutputLogResponse {
  List<ValidationResult> toValidationResults(
      {bool useAlbanianMessage = false}) {
    return processOutputLogDto.map((logDto) {
      return ValidationResult(
        name: logDto.variable,
        entityType: logDto.entityType == 'BUILDING'
            ? EntityType.building
            : logDto.entityType == 'ENTRANCE'
                ? EntityType.entrance
                : EntityType.dwelling,
        message: useAlbanianMessage
            ? logDto.qualityMessageAl
            : logDto.qualityMessageEn,
        level: _mapQualityActionToValidationLevel(logDto.qualityAction),
      );
    }).toList();
  }

  ValidationLevel _mapQualityActionToValidationLevel(String qualityAction) {
    switch (qualityAction.toUpperCase()) {
      case 'ERR':
        return ValidationLevel.error;
      case 'WARN':
        return ValidationLevel.warning;
      case 'INFO':
        return ValidationLevel.info;
      case 'MISS':
        return ValidationLevel.missing;
      case 'QUE':
        return ValidationLevel.question;
      default:
        return ValidationLevel.info; // Default fallback
    }
  }
}
