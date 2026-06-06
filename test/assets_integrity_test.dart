// Verifies that the generated icon maps and the SVG assets shipped with the
// package never drift apart: every constant must point to an existing file
// and every file must have a constant.

// Deprecated aliases are intentionally exercised here:
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fui_kit/fui_kit.dart';

void main() {
  test('registry exposes the 6 styles with 498 icons each', () {
    expect(FuiIcons.styles, hasLength(6));
    for (final entry in FuiIcons.styles.entries) {
      expect(entry.value, hasLength(498),
          reason: '${entry.key} should contain 498 icons');
    }
  });

  test('every icon constant points to an existing SVG asset', () {
    final missing = <String>[];
    for (final style in FuiIcons.styles.entries) {
      for (final icon in style.value.entries) {
        if (!File(icon.value).existsSync()) {
          missing.add('${style.key}/${icon.key} -> ${icon.value}');
        }
      }
    }
    expect(missing, isEmpty,
        reason: 'Constants without a matching asset: $missing');
  });

  test('every SVG asset on disk has a matching constant', () {
    for (final style in FuiIcons.styles.entries) {
      final paths = style.value.values.toSet();
      final dir = Directory(paths.first).parent;
      final onDisk = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.svg'))
          .map((f) => f.path)
          .toSet();
      expect(onDisk.difference(paths), isEmpty,
          reason: '${style.key} has SVG files without a constant — '
              'run `dart run tool/generate_icons.dart`');
    }
  });

  test('deprecated SCREAMING_CASE aliases resolve to the new constants', () {
    expect(RegularRounded.ADDRESS_BOOK, RegularRounded.addressBook);
    expect(BoldStraight.ALARM_CLOCK, BoldStraight.alarmClock);
    expect(SolidRounded.SHOPPING_CART, SolidRounded.shoppingCart);
  });
}
