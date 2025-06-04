import 'package:asrdb/core/enums/validation_level.dart';

class ValidationResult {
  final String name;
  final String message;
  final ValidationLevel level;

  ValidationResult({
    required this.name,
    required this.message,
    required this.level,
  });
}
