import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/validation_level.dart';
import 'package:asrdb/core/models/validation/process_output_log_response.dart';
import 'package:asrdb/core/models/validation/validaton_result.dart';

extension ProcessOutputLogResponseExtension on ProcessOutputLogResponse {
  List<ValidationResult> toValidationResults(
      {bool useAlbanianMessage = false}) {
    return processOutputLogDto.map((logDto) {
      return ValidationResult(
        id: logDto.entityType == 'BUILDING'
            ? logDto.bldId
            : logDto.entityType == 'ENTRANCE'
                ? logDto.entId
                : logDto.dwlId,
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
      case 'AUT':
        return ValidationLevel.automatic;
      case 'ADR':
        return ValidationLevel.address;
      case 'MISS':
        return ValidationLevel.missing;
      case 'QUE':
        return ValidationLevel.question;
      case 'ERR':
        return ValidationLevel.error;
      case 'ESS':
        return ValidationLevel.essential;
      case 'WARN':
        return ValidationLevel.warning;
      case 'INFO':
        return ValidationLevel.info;
      default:
        // Never fall back to a clean-looking level: an action the app does not
        // recognise must stand out rather than read as an automatic value.
        return ValidationLevel.unknown;
    }
  }
}
