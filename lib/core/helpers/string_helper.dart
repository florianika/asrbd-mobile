// core/helpers/string_helper.dart

class StringHelper {
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  static String removeSpaces(String input) {
    return input.replaceAll(RegExp(r"\s+"), "");
  }

  static String? removeCurlyBraces(String? guid) {
    if (guid == null) return null;

    return guid.replaceAll('{', '').replaceAll('}', '');
  }

  static String removeCurlyBracesFromString(String guid) {
    return guid.replaceAll('{', '').replaceAll('}', '');
  }
}

extension GuidCleaner on String? {
  String? removeCurlyBraces() {
    if (this == null) return null;
    return this!.replaceAll('{', '').replaceAll('}', '');
  }
}
