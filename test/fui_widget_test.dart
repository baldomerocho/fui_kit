import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fui_kit/fui_kit.dart';

Widget _wrap(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

void main() {
  testWidgets('renders an SvgPicture', (tester) async {
    await tester.pumpWidget(_wrap(const FUI(RegularRounded.add)));
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('renders every style', (tester) async {
    const icons = [
      BoldRounded.heart,
      BoldStraight.heart,
      RegularRounded.heart,
      RegularStraight.heart,
      SolidRounded.heart,
      SolidStraight.heart,
    ];
    await tester.pumpWidget(_wrap(Row(
      children: [for (final icon in icons) FUI(icon)],
    )));
    expect(find.byType(SvgPicture), findsNWidgets(icons.length));
  });

  testWidgets('applies an explicit color', (tester) async {
    await tester
        .pumpWidget(_wrap(const FUI(RegularRounded.add, color: Colors.blue)));
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
        svg.colorFilter, const ColorFilter.mode(Colors.blue, BlendMode.srcIn));
  });

  testWidgets('applies explicit width and height', (tester) async {
    await tester.pumpWidget(
        _wrap(const FUI(RegularRounded.add, width: 50, height: 40)));
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.width, 50);
    expect(svg.height, 40);
  });

  testWidgets('inherits color and size from the ambient IconTheme',
      (tester) async {
    await tester.pumpWidget(_wrap(const IconTheme(
      data: IconThemeData(color: Colors.teal, size: 40),
      child: FUI(RegularRounded.add),
    )));
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(
        svg.colorFilter, const ColorFilter.mode(Colors.teal, BlendMode.srcIn));
    expect(svg.width, 40);
    expect(svg.height, 40);
  });

  testWidgets('follows the app theme in dark mode', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const Scaffold(body: FUI(RegularRounded.add)),
    ));
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    final expected = IconTheme.of(tester.element(find.byType(FUI))).color;
    expect(svg.colorFilter, ColorFilter.mode(expected!, BlendMode.srcIn));
  });

  testWidgets('falls back to a 24px icon without an IconTheme', (tester) async {
    await tester.pumpWidget(_wrap(const FUI(RegularRounded.add)));
    final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svg.width, 24);
    expect(svg.height, 24);
  });

  testWidgets('exposes semanticLabel to the semantics tree', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
        _wrap(const FUI(RegularRounded.add, semanticLabel: 'Add item')));
    expect(find.bySemanticsLabel('Add item'), findsOneWidget);
    handle.dispose();
  });
}
