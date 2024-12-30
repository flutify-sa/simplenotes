import 'dart:convert';

import 'package:notes/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteManager {
  static const String notesKey = 'notes';

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notesJson =
        notes.map((note) => jsonEncode(note.toMap())).toList();
    prefs.setStringList(notesKey, notesJson);
  }

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? notesJson = prefs.getStringList(notesKey);
    if (notesJson != null) {
      return notesJson
          .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
          .toList();
    }
    return [];
  }
}
