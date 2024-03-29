import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fui_kit/fui_kit.dart';

void main() {
  testWidgets("FUI should render a SvgPicture",
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const FUI(
      RegularRounded.ADD,
      color: Colors.blue,
      height: 50,
    ));
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets("FUI should render a SvgPicture with the correct color",
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const FUI(
      RegularRounded.ADD,
      color: Colors.blue,
      height: 50,
    ));
    final svgPicture = widgetTester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svgPicture.colorFilter,
        const ColorFilter.mode(Colors.blue, BlendMode.srcIn));
  });

  testWidgets("FUI should render a SvgPicture with the correct height",
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const FUI(
      RegularRounded.ADD,
      color: Colors.blue,
      height: 50,
    ));
    final svgPicture = widgetTester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svgPicture.height, 50);
  });

  testWidgets("FUI should render a SvgPicture with the null color",
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const FUI(
      RegularRounded.ADD,
      height: 50,
    ));
    final svgPicture = widgetTester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svgPicture.colorFilter,
        ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn));
  });
}
