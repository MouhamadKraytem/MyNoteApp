import 'package:flutter/material.dart';
import 'package:myapp/Services/NoteServices.dart';
import 'package:provider/provider.dart';

import '../Models/Note.dart';
import 'dart:math';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late double _deviceHeight = MediaQuery.of(context).size.height;
  late double _deviceWidth = MediaQuery.of(context).size.width;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      Note newNote = Note(
        title: title,
        decription: description,
      );

      Provider.of<NoteServices>(context, listen: false).addNote(newNote);
      Navigator.pop(context); // Return to previous screen after saving
      print("saved");
    } else {
      // Show a warning if either field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Both title and description are required.')),
      );
      print("not saved");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _buttonSize = 20;
    Color buttonBackgroundColor = Color(0xFF3B3B3B);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(
              fixedSize: Size(_buttonSize, _buttonSize),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: buttonBackgroundColor,
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                //save
                _saveNote();
              },
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                fixedSize: Size(_buttonSize, _buttonSize),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: buttonBackgroundColor,
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Consumer<NoteServices>(
          builder: (context, noteServices, child) {
            return NewNoteForm();
          },
        ));
  }

  Widget NewNoteForm() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: null,
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
