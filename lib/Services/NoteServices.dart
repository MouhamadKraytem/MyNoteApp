import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/Models/Note.dart';

class NoteServices extends ChangeNotifier{
  late Box<Note> noteBox;

  Future<void> initializeBox() async {
    noteBox = await Hive.openBox<Note>('noteList');
    notifyListeners();
  }

  List<Note> get notes => noteBox.values.toList();

  void addNote(Note note) {
    noteBox.add(note);
    notifyListeners(); // Notify listeners about the change
  }

  void updateNote(int index, Note updatedNote) {
    noteBox.putAt(index, updatedNote); // Update note at specified index
    notifyListeners(); // Notify listeners about the change
  }

  void deleteNote(int index) {
    noteBox.deleteAt(index); // Delete note at specified index
    notifyListeners(); // Notify listeners about the change
  }

  Box<Note> get getnoteBox {
    if (noteBox.isOpen) {
      return noteBox;
    } else {
      throw ErrorDescription('NoteBox is not opened yet!');
    }
  }


}