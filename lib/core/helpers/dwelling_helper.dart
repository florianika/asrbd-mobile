import 'package:asrdb/core/constants/default_data.dart';

class DwellingHelper {
  static Map<String, List<Map<String, dynamic>>> groupDwellingsByFloor(
      List<Map<String, dynamic>> dwellingRows) {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final dwelling in dwellingRows) {
      final floor = dwelling['DwlFloor']?.toString() ?? 'Unknown';
      if (!grouped.containsKey(floor)) {
        grouped[floor] = [];
      }
      grouped[floor]!.add(dwelling);
    }

    // Sort floors numerically
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == 'Unknown') return 1;
        if (b == 'Unknown') return -1;
        final aNum = int.tryParse(a) ?? 0;
        final bNum = int.tryParse(b) ?? 0;
        return aNum.compareTo(bNum);
      });

    return Map.fromEntries(
        sortedKeys.map((key) => MapEntry(key, grouped[key]!)));
  }

  static bool floorHasErrors(List<Map<String, dynamic>> dwellings) {
    return dwellings.any((dwelling) {
      final raw = dwelling['DwlQuality'];
      final quality = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
      // Statuses 3, 4 and 5: missing, inconsistent or not ready for statistics.
      return DefaultData.qualityProblemCodes.contains(quality);
    });
  }
}
