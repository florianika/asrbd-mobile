import 'package:flutter/material.dart';

/// Severity of a single QMS output-log row, derived from its `qualityAction`.
///
/// The colour of each level follows the data-validation specification:
/// green marks automatically calculated variables, orange marks missing
/// statistical data (quality status 3) and red marks data that is either
/// inconsistent or not ready for statistics (quality statuses 4 and 5).
enum ValidationLevel {
  /// `AUT` — variable calculated automatically by the QMS.
  automatic,

  /// `ADR` — address discrepancy, contributes quality status 2.
  address,

  /// `MISS` — missing statistical data, contributes quality status 3.
  missing,

  /// `QUE` — inconsistent statistical data, contributes quality status 4.
  question,

  /// `ERR` — inconsistent statistical data, contributes quality status 4.
  error,

  /// `ESS` — data not ready for statistics, contributes quality status 5.
  essential,

  /// `WARN` — legacy warning, kept so older rows still render.
  warning,

  /// `INFO` — legacy informational note, kept so older rows still render.
  info,

  /// Unrecognised `qualityAction`. Rendered as an error so that a value the
  /// app does not understand can never be mistaken for a clean field.
  unknown,
}

extension ValidationLevelExtension on ValidationLevel {
  /// Colour used for the field border, icon and message text.
  Color get color {
    switch (this) {
      case ValidationLevel.automatic:
        return Colors.green;
      case ValidationLevel.address:
      case ValidationLevel.info:
        return Colors.blue;
      case ValidationLevel.missing:
      case ValidationLevel.warning:
        return Colors.orange;
      case ValidationLevel.question:
      case ValidationLevel.error:
      case ValidationLevel.essential:
      case ValidationLevel.unknown:
        return Colors.red;
    }
  }

  /// Icon shown next to the validation message.
  IconData get icon {
    switch (this) {
      case ValidationLevel.automatic:
        return Icons.calculate_outlined;
      case ValidationLevel.address:
      case ValidationLevel.info:
        return Icons.info_outline;
      case ValidationLevel.missing:
      case ValidationLevel.warning:
        return Icons.warning_amber_outlined;
      case ValidationLevel.question:
        return Icons.help_outline;
      case ValidationLevel.error:
      case ValidationLevel.unknown:
        return Icons.error_outline;
      case ValidationLevel.essential:
        return Icons.report_problem_outlined;
    }
  }

  /// Whether this level represents a problem the surveyor has to act on.
  ///
  /// `automatic` is an annotation rather than an error, and `address` maps to
  /// quality status 2 (statistically error-free), so neither blocks statistics.
  bool get isProblem {
    switch (this) {
      case ValidationLevel.automatic:
      case ValidationLevel.address:
        return false;
      case ValidationLevel.missing:
      case ValidationLevel.question:
      case ValidationLevel.error:
      case ValidationLevel.essential:
      case ValidationLevel.warning:
      case ValidationLevel.info:
      case ValidationLevel.unknown:
        return true;
    }
  }
}
