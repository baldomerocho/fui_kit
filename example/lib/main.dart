import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fui_kit/fui_kit.dart';

void main() => runApp(const GalleryApp());

/// Searchable gallery of every fui_kit icon.
///
/// Tap any icon to copy its `FUI(...)` snippet to the clipboard.
class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fui_kit gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: GalleryPage(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _style = 'Regular Rounded';
  String _query = '';

  /// Converts a kebab-case icon name into its Dart constant name:
  /// `address-book` -> `addressBook`.
  static String _camel(String kebab) {
    final parts = kebab.split('-');
    return parts.first +
        parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  String _snippetFor(String iconName) {
    final className = _style.replaceAll(' ', '');
    return 'FUI($className.${_camel(iconName)})';
  }

  Future<void> _copySnippet(String iconName) async {
    final snippet = _snippetFor(iconName);
    await Clipboard.setData(ClipboardData(text: snippet));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Copied: $snippet'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final icons = FuiIcons.styles[_style]!;
    final filtered = _query.isEmpty
        ? icons.entries.toList()
        : icons.entries
            .where((e) => e.key.contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('fui_kit gallery'),
        actions: [
          IconButton(
            tooltip: widget.isDark ? 'Light mode' : 'Dark mode',
            onPressed: widget.onToggleTheme,
            icon: FUI(
              widget.isDark ? RegularRounded.sun : RegularRounded.moon,
              semanticLabel: widget.isDark ? 'Light mode' : 'Dark mode',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search ${icons.length} icons…',
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: FUI(RegularRounded.search, width: 20, height: 20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final name in FuiIcons.styles.keys)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(name),
                      selected: _style == name,
                      onSelected: (_) => setState(() => _style = name),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} icons — tap to copy the code snippet',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 110,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final entry = filtered[index];
                return Tooltip(
                  message: _snippetFor(entry.key),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _copySnippet(entry.key),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FUI(entry.value, width: 28, height: 28),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            entry.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
