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
        body: const TabBarView(
          children: <Widget>[
            FormatToolbar(),
            InsertToolbar(),
            ReviewToolbar(),
            ExportToolbar(),
          ],
        ),
      ),
    );
  }
}

class FormatToolbar extends StatelessWidget {
  const FormatToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.format_bold), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_italic), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_underlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.strikethrough_s), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_size), onPressed: () {}), // font size
            IconButton(icon: const Icon(Icons.format_color_text), onPressed: () {}), // text color
            IconButton(icon: const Icon(Icons.format_color_fill), onPressed: () {}), // highlight
            IconButton(icon: const Icon(Icons.format_align_left), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_align_center), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_align_right), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_align_justify), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_list_numbered), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_indent_increase), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_indent_decrease), onPressed: () {}),
            IconButton(icon: const Icon(Icons.format_line_spacing), onPressed: () {}), // line spacing!
            IconButton(icon: const Icon(Icons.format_quote), onPressed: () {}),
            IconButton(icon: const Icon(Icons.font_download), onPressed: () {}), // font family,
          ],
        ),
      ),
    );

  }
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