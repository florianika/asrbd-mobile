// core/constants/regex_patterns.dart

class RegexPatterns {
  static const String email = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phone = r'^\+?[1-9]\d{1,14}$'; // E.164 phone number format
}
