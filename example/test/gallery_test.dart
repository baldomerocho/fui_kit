import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fui_kit/fui_kit.dart';
import 'package:fui_kit_example/main.dart';

void main() {
  testWidgets('gallery renders the grid of icons', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    expect(find.text('fui_kit gallery'), findsOneWidget);
    expect(find.byType(FUI), findsWidgets);
    expect(
        find.text('498 icons — tap to copy the code snippet'), findsOneWidget);
  });

  testWidgets('search filters the icons', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    await tester.enterText(find.byType(TextField), 'heart');
    await tester.pump();
    final label = tester
        .widget<Text>(find.textContaining('tap to copy the code snippet'))
        .data!;
    final count = int.parse(label.split(' ').first);
    expect(count, greaterThan(0));
    expect(count, lessThan(498));
    expect(
        find.descendant(
            of: find.byType(GridView), matching: find.text('heart')),
        findsOneWidget);
  });

  testWidgets('style chips switch the icon set', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    await tester.tap(find.text('Bold Rounded'));
    await tester.pump();
    final chip = tester.widget<ChoiceChip>(find.ancestor(
        of: find.text('Bold Rounded'), matching: find.byType(ChoiceChip)));
    expect(chip.selected, isTrue);
  });

  testWidgets('theme toggle switches to dark mode', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    await tester.tap(find.byTooltip('Dark mode'));
    await tester.pump();
    expect(find.byTooltip('Light mode'), findsOneWidget);
  });
}
