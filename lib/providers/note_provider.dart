import 'package:flutter/material.dart';

class Note {
  final String title;
  final String content;

  Note({
    required this.title,
    required this.content,
  });
}

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(String title, String content) {
    _notes.add(Note(
      title: title,
      content: content,
    ));
    notifyListeners();
  }

  void updateNote(int index, String title, String content) {
    _notes[index] = Note(
      title: title,
      content: content,
    );
    notifyListeners();
  }

  void removeNoteAt(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }
}
