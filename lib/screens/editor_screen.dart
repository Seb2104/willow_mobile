import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import '../models/document_model.dart';
import '../services/document_storage.dart';

class EditorScreen extends StatefulWidget {
  final String? documentId;

  const EditorScreen({super.key, this.documentId});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final MutableDocument _document;
  late final MutableDocumentComposer _composer;
  late final Editor _editor;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  String? _documentId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _documentId = widget.documentId;
    _initializeEditor();
  }

  Future<void> _initializeEditor() async {
    if (_documentId != null) {
      final existing = await DocumentStorage.getDocument(_documentId!);
      if (existing != null) {
        _document = MutableDocument(
          nodes: _deserializeContent(existing.content),
        );
      } else {
        _document = _createEmptyDocument();
      }
    } else {
      _document = _createEmptyDocument();
    }

    _composer = MutableDocumentComposer();
    _editor = createDefaultDocumentEditor(
      document: _document,
      composer: _composer,
    );

    _focusNode = FocusNode();
    _scrollController = ScrollController();

    setState(() => _isLoading = false);
  }

  MutableDocument _createEmptyDocument() {
    return MutableDocument(
      nodes: [
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(),
        ),
      ],
    );
  }

//SAVE ME AND DELETE MEE

  Future<void> _saveDocument() async {
    final now = DateTime.now();

    final doc = DocumentModel(
      id: _documentId ?? DocumentStorage.generateId(),
      title: 'Untitled',
      content: _serializeContent(),
      createdAt: now,
      modifiedAt: now,
    );

    await DocumentStorage.saveDocument(doc);

    setState(() => _documentId = doc.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document saved')),
      );
    }
  }

  Future<void> _deleteDocument() async {
    if (_documentId == null) return;

    await DocumentStorage.deleteDocument(_documentId!);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

 //CERIALIZATION

  String _serializeContent() {
    final buffer = StringBuffer();

    for (final node in _document) {
      if (node is TextNode) {
        buffer.writeln(node.text.text);
      } else if (node is HorizontalRuleNode) {
        buffer.writeln('---');
      }
    }

    return buffer.toString();
  }

  List<DocumentNode> _deserializeContent(String content) {
    final lines = content.split('\n');
    final nodes = <DocumentNode>[];

    for (final line in lines) {
      if (line == '---') {
        nodes.add(HorizontalRuleNode(id: Editor.createNodeId()));
      } else {
        nodes.add(
          ParagraphNode(
            id: Editor.createNodeId(),
            text: AttributedText(line),
          ),
        );
      }
    }

    if (nodes.isEmpty) {
      nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(),
        ),
      );
    }

    return nodes;
  }

//PENOUTHG

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument,
            tooltip: 'Save',
          ),
          if (_documentId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteDocument,
              tooltip: 'Delete',
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildToolbar(),
        ),
      ),
      body: SuperEditor(
        editor: _editor,
        focusNode: _focusNode,
        scrollController: _scrollController,
        stylesheet: _buildStylesheet(),
      ),
    );
  }

 //TOOLY BARRRRR

  Widget _buildToolbar() {
    final selection = _composer.selection;
    final selectedAttributions = _getSelectedAttributions();

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey[200],
      child: Row(
        children: [
          _toggleButton(Icons.format_bold, boldAttribution, selectedAttributions),
          _toggleButton(Icons.format_italic, italicsAttribution, selectedAttributions),
          _toggleButton(Icons.format_underlined, underlineAttribution, selectedAttributions),
          _toggleButton(Icons.strikethrough_s, strikethroughAttribution, selectedAttributions),
        ],
      ),
    );
  }

  Widget _toggleButton(
      IconData icon,
      Attribution attribution,
      Set<Attribution> selected,
      ) {
    return IconButton(
      icon: Icon(icon),
      color: selected.contains(attribution) ? Colors.blue : Colors.black87,
      onPressed: () => _toggleAttribution(attribution),
    );
  }

  Set<Attribution> _getSelectedAttributions() {
    final selection = _composer.selection;
    if (selection == null || selection.isCollapsed) return {};

    final node = _document.getNodeById(selection.base.nodeId);
    if (node is! TextNode) return {};

    final offset = (selection.base.nodePosition as TextNodePosition).offset;
    return node.text.getAllAttributionsAt(offset);
  }

  void _toggleAttribution(Attribution attribution) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      ToggleTextAttributionsRequest(
        documentRange: DocumentRange(
          start: selection.base,
          end: selection.extent,
        ),
        attributions: {attribution},
      ),
    ]);
  }

  Stylesheet _buildStylesheet() {
    return defaultStylesheet.copyWith(
      addRulesAfter: [
        StyleRule(
          BlockSelector.all,
              (_, __) => {
            Styles.padding: const CascadingPadding.symmetric(vertical: 8),
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
