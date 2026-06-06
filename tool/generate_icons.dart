// Icon map generator for fui_kit.
//
// Scans `assets/icons/<weight>/<corner>/svg/*.svg` and generates one Dart
// file per style under `lib/src/styles/`, plus an aggregated registry.
//
// Usage (from the package root):
//   dart run tool/generate_icons.dart
//
// Each generated class contains:
//   - one lowerCamelCase `String` constant per icon (the asset path),
//   - a deprecated SCREAMING_CASE alias per icon (removed in v4.0.0),
//   - an `all` map (kebab-case icon name -> asset path) used by tests
//     and by the example gallery.

import 'dart:io';

const _styles = [
  (
    className: 'BoldRounded',
    fileName: 'bold_rounded',
    dir: 'assets/icons/bold/rounded/svg',
    prefix: 'fi-br-',
    label: 'Bold Rounded',
  ),
  (
    className: 'BoldStraight',
    fileName: 'bold_straight',
    dir: 'assets/icons/bold/straight/svg',
    prefix: 'fi-bs-',
    label: 'Bold Straight',
  ),
  (
    className: 'RegularRounded',
    fileName: 'regular_rounded',
    dir: 'assets/icons/regular/rounded/svg',
    prefix: 'fi-rr-',
    label: 'Regular Rounded',
  ),
  (
    className: 'RegularStraight',
    fileName: 'regular_straight',
    dir: 'assets/icons/regular/straight/svg',
    prefix: 'fi-rs-',
    label: 'Regular Straight',
  ),
  (
    className: 'SolidRounded',
    fileName: 'solid_rounded',
    dir: 'assets/icons/solid/rounded/svg',
    prefix: 'fi-sr-',
    label: 'Solid Rounded',
  ),
  (
    className: 'SolidStraight',
    fileName: 'solid_straight',
    dir: 'assets/icons/solid/straight/svg',
    prefix: 'fi-ss-',
    label: 'Solid Straight',
  ),
];

/// Dart reserved words that cannot be used as identifiers.
const _reservedWords = {
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with',
};

/// Converts a kebab-case icon name into a valid lowerCamelCase identifier.
String camelIdentifier(String kebab) {
  final parts = kebab.split('-').where((p) => p.isNotEmpty).toList();
  final buffer = StringBuffer(parts.first);
  for (final part in parts.skip(1)) {
    buffer.write(part[0].toUpperCase() + part.substring(1));
  }
  var identifier = buffer.toString();
  if (RegExp(r'^[0-9]').hasMatch(identifier)) identifier = 'i$identifier';
  if (_reservedWords.contains(identifier)) identifier = '${identifier}Icon';
  return identifier;
}

/// Converts a kebab-case icon name into the legacy SCREAMING_CASE identifier
/// used by fui_kit <= 2.0.x. Must match the old generator exactly.
String legacyIdentifier(String kebab) =>
    kebab.toUpperCase().replaceAll('-', '_');

void main() {
  final timestamp = DateTime.now().toUtc().toIso8601String();
  final summary = <String, int>{};

  for (final style in _styles) {
    final dir = Directory(style.dir);
    if (!dir.existsSync()) {
      stderr.writeln('Missing icon directory: ${style.dir}');
      exitCode = 1;
      return;
    }

    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.svg'))
        .map((f) => f.uri.pathSegments.last)
        .toList()
      ..sort();

    final icons = <({String kebab, String file, String path})>[];
    for (final file in files) {
      final kebab = file
          .replaceFirst(style.prefix, '')
          .replaceFirst(RegExp(r'\.svg$'), '');
      if (!RegExp(r'^[a-z0-9-]+$').hasMatch(kebab)) {
        stderr.writeln('Unexpected icon name "$file" in ${style.dir}');
        exitCode = 1;
        return;
      }
      icons.add((kebab: kebab, file: file, path: '${style.dir}/$file'));
    }

    final out = StringBuffer()
      ..writeln('// GENERATED FILE - DO NOT EDIT BY HAND.')
      ..writeln('//')
      ..writeln('// Regenerate with: dart run tool/generate_icons.dart')
      ..writeln('// Generated on $timestamp from ${style.dir}.')
      ..writeln('')
      ..writeln('// Legacy SCREAMING_CASE aliases are kept until v4.0.0:')
      ..writeln('// ignore_for_file: constant_identifier_names')
      ..writeln('')
      ..writeln('/// The **${style.label}** icon set (${icons.length} icons).')
      ..writeln('///')
      ..writeln('/// Every constant is the asset path of one SVG icon, ready')
      ..writeln('/// to be rendered with the `FUI` widget:')
      ..writeln('///')
      ..writeln('/// ```dart')
      ..writeln(
          '/// FUI(${style.className}.${camelIdentifier(icons.first.kebab)})')
      ..writeln('/// ```')
      ..writeln('abstract final class ${style.className} {');

    for (final icon in icons) {
      final camel = camelIdentifier(icon.kebab);
      out
        ..writeln('  /// The `${icon.kebab}` icon (${icon.file}).')
        ..writeln("  static const String $camel = '${icon.path}';")
        ..writeln('');
    }

    for (final icon in icons) {
      final camel = camelIdentifier(icon.kebab);
      final legacy = legacyIdentifier(icon.kebab);
      if (legacy == camel) continue;
      out
        ..writeln('  /// Deprecated alias of [$camel].')
        ..writeln("  @Deprecated('Use ${style.className}.$camel instead. '")
        ..writeln("      'This alias will be removed in fui_kit 4.0.0.')")
        ..writeln('  static const String $legacy = $camel;')
        ..writeln('');
    }

    out
      ..writeln('  /// All ${style.label} icons, keyed by kebab-case name.')
      ..writeln('  ///')
      ..writeln('  /// Useful to build galleries, pickers or searches.')
      ..writeln('  static const Map<String, String> all = {');
    for (final icon in icons) {
      out.writeln("    '${icon.kebab}': ${camelIdentifier(icon.kebab)},");
    }
    out
      ..writeln('  };')
      ..writeln('}');

    File('lib/src/styles/${style.fileName}.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync(out.toString());
    summary[style.className] = icons.length;
  }

  // Aggregated registry of every style, for galleries and tooling.
  final registry = StringBuffer()
    ..writeln('// GENERATED FILE - DO NOT EDIT BY HAND.')
    ..writeln('//')
    ..writeln('// Regenerate with: dart run tool/generate_icons.dart')
    ..writeln('// Generated on $timestamp.')
    ..writeln('')
    ..writeln("import 'package:fui_kit/src/styles/bold_rounded.dart';")
    ..writeln("import 'package:fui_kit/src/styles/bold_straight.dart';")
    ..writeln("import 'package:fui_kit/src/styles/regular_rounded.dart';")
    ..writeln("import 'package:fui_kit/src/styles/regular_straight.dart';")
    ..writeln("import 'package:fui_kit/src/styles/solid_rounded.dart';")
    ..writeln("import 'package:fui_kit/src/styles/solid_straight.dart';")
    ..writeln('')
    ..writeln('/// Registry of every fui_kit icon style.')
    ..writeln('///')
    ..writeln('/// Maps a human readable style name to that style\'s icon map')
    ..writeln('/// (kebab-case icon name -> SVG asset path).')
    ..writeln('abstract final class FuiIcons {')
    ..writeln('  /// All icon styles shipped with fui_kit.')
    ..writeln('  static const Map<String, Map<String, String>> styles = {');
  for (final style in _styles) {
    registry.writeln("    '${style.label}': ${style.className}.all,");
  }
  registry
    ..writeln('  };')
    ..writeln('}');

  File('lib/src/styles/fui_icons.dart').writeAsStringSync(registry.toString());

  final total = summary.values.fold<int>(0, (a, b) => a + b);
  stdout.writeln('Generated ${summary.length} styles, $total icons total:');
  summary.forEach((name, count) => stdout.writeln('  $name: $count'));
}
