import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';

/// FUI is a widget that allows you to use the icons from the FUI Kit.
class FUI extends StatelessWidget {
  /// The file name of the icon.
  final String file;

  /// The width of the icon.
  final double? width;

  /// The height of the icon.
  final double? height;

  /// The color of the icon.
  final Color? color;

  const FUI(
      {Key? key, required this.file, this.width, this.height = 30, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (width == null && height == null && color == null) {
      return SvgPicture.asset(file, package: 'fui_kit');
    } else if (width == null && height == null) {
      return SvgPicture.asset(file, color: color, package: 'fui_kit');
    } else if (width == null && color == null) {
      return SvgPicture.asset(file, height: height, package: 'fui_kit');
    } else if (height == null && color == null) {
      return SvgPicture.asset(file, width: width, package: 'fui_kit');
    } else if (width == null) {
      return SvgPicture.asset(file,
          height: height, color: color, package: 'fui_kit');
    } else if (height == null) {
      return SvgPicture.asset(file,
          width: width, color: color, package: 'fui_kit');
    } else if (color == null) {
      return SvgPicture.asset(file,
          width: width, height: height, package: 'fui_kit');
    } else {
      return SvgPicture.asset(file,
          width: width, height: height, color: color, package: 'fui_kit');
    }
  }
}
