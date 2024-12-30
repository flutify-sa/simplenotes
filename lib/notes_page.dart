// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:notes/note.dart';
import 'package:notes/note_manager.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  final NoteManager noteManager = NoteManager();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    notes = await noteManager.getNotes();
    setState(() {});
  }

  void saveNotes() async {
    await noteManager.saveNotes(notes);
  }

  void _openNoteDialog({Note? note, int? index}) {
    TextEditingController titleController =
        TextEditingController(text: note?.title ?? '');
    TextEditingController contentController =
        TextEditingController(text: note?.content ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'New Note' : 'Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  maxLines: null, // Allow the content field to expand
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (note == null) {
                  setState(() {
                    notes.add(Note(
                      title: titleController.text,
                      content: contentController.text,
                    ));
                  });
                } else {
                  setState(() {
                    notes[index!] = Note(
                      title: titleController.text,
                      content: contentController.text,
                    );
                  });
                }
                saveNotes();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Center(
          child: Text('Notes'),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.fill,
            ),
          ),

          // Notes list
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25.0),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      tileColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                      title: Text(
                        notes[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        notes[index].content,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () => _openNoteDialog(
                                note: notes[index], index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                      onTap: () {
                        _openNoteDialog(note: notes[index], index: index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => _openNoteDialog(),
              backgroundColor: Colors.greenAccent.shade700,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
