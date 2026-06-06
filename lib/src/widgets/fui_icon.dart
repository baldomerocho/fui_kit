import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders an SVG icon from the fui_kit collection.
///
/// Pass any constant from one of the six style classes ([BoldRounded],
/// [BoldStraight], [RegularRounded], [RegularStraight], [SolidRounded],
/// [SolidStraight]):
///
/// ```dart
/// const FUI(RegularRounded.heart)
/// ```
///
/// Like the Material [Icon] widget, `FUI` honours the ambient [IconTheme]:
/// when [color], [width] or [height] are not provided, the icon uses
/// `IconTheme.of(context).color` and `IconTheme.of(context).size`. This means
/// icons automatically adapt to light/dark themes and look correct inside
/// [IconButton], [AppBar], [BottomNavigationBar], etc.
///
/// ```dart
/// IconButton(
///   onPressed: () {},
///   icon: const FUI(BoldRounded.settings),
/// )
/// ```
///
/// Provide a [semanticLabel] so screen readers can announce the icon:
///
/// ```dart
/// FUI(SolidRounded.trash, semanticLabel: 'Delete item')
/// ```
class FUI extends StatelessWidget {
  /// Creates a fui_kit icon.
  ///
  /// [file] is the SVG asset path of the icon, normally one of the constants
  /// exposed by the style classes (for example [RegularRounded.add]).
  const FUI(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.color,
    this.semanticLabel,
    this.fit = BoxFit.contain,
    this.matchTextDirection = false,
  });

  /// The SVG asset path of the icon, e.g. [RegularRounded.add].
  final String file;

  /// The width of the icon.
  ///
  /// Defaults to the ambient [IconTheme] size (24 when there is none).
  final double? width;

  /// The height of the icon.
  ///
  /// Defaults to the ambient [IconTheme] size (24 when there is none).
  final double? height;

  /// The color used to tint the icon.
  ///
  /// Defaults to the ambient [IconTheme] color, so icons follow the active
  /// light/dark theme out of the box.
  final Color? color;

  /// A description of the icon announced by screen readers.
  final String? semanticLabel;

  /// How the icon is inscribed into its bounds.
  final BoxFit fit;

  /// Whether the icon should be flipped horizontally in right-to-left
  /// locales (useful for directional icons like arrows).
  final bool matchTextDirection;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final fallbackSize = iconTheme.size ?? 24.0;
    final resolvedColor = color ?? iconTheme.color;

    return SvgPicture.asset(
      file,
      package: 'fui_kit',
      width: width ?? fallbackSize,
      height: height ?? fallbackSize,
      fit: fit,
      matchTextDirection: matchTextDirection,
      semanticsLabel: semanticLabel,
      colorFilter: resolvedColor != null
          ? ColorFilter.mode(resolvedColor, BlendMode.srcIn)
          : null,
    );
  }
}
