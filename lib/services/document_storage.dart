import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document_model.dart';

class DocumentStorage {
  static const String _storageKey = 'willow_documents';

  static Future<List<DocumentModel>> loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveDocuments(List<DocumentModel> documents) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = documents.map((doc) => doc.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  static Future<DocumentModel?> getDocument(String id) async {
    final documents = await loadDocuments();
    try {
      return documents.firstWhere((doc) => doc.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveDocument(DocumentModel document) async {
    final documents = await loadDocuments();
    final index = documents.indexWhere((doc) => doc.id == document.id);

    if (index >= 0) {
      documents[index] = document;
    } else {
      documents.add(document);
    }

    await saveDocuments(documents);
  }

  static Future<void> deleteDocument(String id) async {
    final documents = await loadDocuments();
    documents.removeWhere((doc) => doc.id == id);
    await saveDocuments(documents);
  }

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
