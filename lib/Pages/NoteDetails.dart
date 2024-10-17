import 'package:flutter/material.dart';

import '../Models/Note.dart';

class NoteDetails extends StatefulWidget {
  Note note;
  NoteDetails({super.key, required this.note});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Text("note delails")
      ),
    );
  }
}
