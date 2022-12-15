import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/widgets.dart';

class FUI extends StatelessWidget {
  final String file;
  final double? width;
  final double? height;
  final Color? color;
  const FUI({Key? key,required this.file, this.width, this.height = 30, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(width == null && height == null && color == null) {
      return SvgPicture.asset(file, package: 'fui');
    } else if(width == null && height == null) {
      return SvgPicture.asset(file, color: color, package: 'fui');
    } else if(width == null && color == null) {
      return SvgPicture.asset(file, height: height, package: 'fui');
    } else if(height == null && color == null) {
      return SvgPicture.asset(file, width: width, package: 'fui');
    } else if(width == null) {
      return SvgPicture.asset(file, height: height, color: color, package: 'fui');
    } else if(height == null) {
      return SvgPicture.asset(file, width: width, color: color, package: 'fui');
    } else if(color == null) {
      return SvgPicture.asset(file, width: width, height: height, package: 'fui');
    } else {
      return SvgPicture.asset(file, width: width, height: height, color: color, package: 'fui');
    }
  }
}
