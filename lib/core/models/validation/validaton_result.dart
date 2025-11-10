import 'package:asrdb/core/enums/entity_type.dart';
import 'package:asrdb/core/enums/validation_level.dart';

class ValidationResult {
  final String? id;
  final String name;
  final String message;
  final EntityType entityType;
  final ValidationLevel level;

  ValidationResult({
    required this.id,
    required this.name,
    required this.message,
    required this.entityType,
    required this.level,
  });
}
