import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 10,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Format'),
              Tab(text: 'Insert'),
              Tab(text: 'Review'),
              Tab(text: 'Export'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FormatToolbar(),
            const InsertToolbar(),
            const ReviewToolbar(),
            const ExportToolbar(),
          ],
        ),
      ),
    );
  }
}

class FormatToolbar extends StatefulWidget {
  const FormatToolbar({super.key});

  @override
  State<FormatToolbar> createState() => _FormatToolbarState();
}

class _FormatToolbarState extends State<FormatToolbar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(icon: betterIcon(Icons.format_bold), onPressed: () {}),
                IconButton(icon: betterIcon(Icons.format_italic), onPressed: () {}),
                IconButton(
                  icon: betterIcon(Icons.format_underlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: betterIcon(Icons.strikethrough_s),
                  onPressed: () {},
                ),
                IconButton(icon: betterIcon(Icons.format_size), onPressed: () {}),
                IconButton(
                  icon: betterIcon(Icons.format_color_text),
                  onPressed: () {},
                ),
                IconButton(
                  icon: betterIcon(
                      _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            if (_isExpanded)
              Row(
                children: [
                  IconButton(
                    icon: betterIcon(Icons.format_color_fill),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_align_left),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_align_center),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_align_right),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_align_justify),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_list_bulleted),
                    onPressed: () {},
                  ),
                ],
              ),
            if (_isExpanded)
              Row(
                children: [
                  IconButton(
                    icon: betterIcon(Icons.format_list_numbered),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_indent_increase),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_indent_decrease),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: betterIcon(Icons.format_line_spacing),
                    onPressed: () {},
                  ),
                  IconButton(icon: betterIcon(Icons.format_quote), onPressed: () {}),
                  IconButton(icon: betterIcon(Icons.font_download), onPressed: () {}),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

double _iconSize = 24;

Widget betterIcon(IconData icon) {
  return Icon(icon, size: _iconSize);
}

class InsertToolbar extends StatelessWidget {
  const InsertToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.image), onPressed: () {}),
            IconButton(icon: const Icon(Icons.link), onPressed: () {}),
            IconButton(icon: const Icon(Icons.table_chart), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class ReviewToolbar extends StatelessWidget {
  const ReviewToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.spellcheck), onPressed: () {}),
            IconButton(icon: const Icon(Icons.comment), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class ExportToolbar extends StatelessWidget {
  const ExportToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            IconButton(icon: const Icon(Icons.download), onPressed: () {}),
            IconButton(icon: const Icon(Icons.print), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}