import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// FUI is a widget that allows you to use the icons from the FUI Kit.
class FUI extends StatelessWidget {
  /// The file name of the icon.
  final String file;

  /// The width of the icon.
  final double width;

  /// The height of the icon.
  final double height;

  /// The color of the icon.
  final Color? color;

  /// Icons Types:
  /// - BoldRounded
  /// - BoldStraight
  /// - RegularRounded
  /// - RegularStraight
  /// - SolidRounded
  /// - SolidStraight
  ///
  /// Example:
  /// ```dart
  /// FUI(BoldRounded.ADD)
  /// ```
  ///
  const FUI(this.file,
      {super.key, this.width = 30, this.height = 30, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    final nullColor =
        theme == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600;

    return SvgPicture.asset(file,
        package: 'fui_kit',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : ColorFilter.mode(nullColor, BlendMode.srcIn));
  }
}
