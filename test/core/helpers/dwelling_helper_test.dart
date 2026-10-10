import 'package:asrdb/core/helpers/dwelling_helper.dart';
import 'package:flutter_test/flutter_test.dart';

bool _flagged(Object? quality) => DwellingHelper.floorHasErrors([
      {'DwlQuality': quality}
    ]);

void main() {
  test('missing data alone does not flag a floor as having problems', () {
    // 3 = "Mungesa në të dhënat statistikore"
    expect(_flagged(3), isFalse);
  });

  test('inconsistent or not-ready data flags the floor', () {
    // 4 = "Të dhëna statistikore kontradiktore"
    expect(_flagged(4), isTrue);
    // 5 = "Të dhëna jo të gatshme për statistika"
    expect(_flagged(5), isTrue);
  });

  test('clean, untested, deleted and unset quality are not flagged', () {
    for (final quality in [1, 2, 9, 0, null]) {
      expect(_flagged(quality), isFalse, reason: 'quality $quality');
    }
  });

  test('one problem dwelling is enough to flag a floor', () {
    expect(
      DwellingHelper.floorHasErrors([
        {'DwlQuality': 3},
        {'DwlQuality': 1},
        {'DwlQuality': 4},
      ]),
      isTrue,
    );
  });
}
