import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/Note.dart';
import '../Services/NoteServices.dart';

class NoteDetails extends StatefulWidget {
  final Note note; // Make note final
  NoteDetails({super.key, required this.note});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late double _deviceHeight = MediaQuery.of(context).size.height;
  late double _deviceWidth = MediaQuery.of(context).size.width;

  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _descriptionController.text = widget.note.decription;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _buttonSize = 20;
    Color buttonBackgroundColor = Color(0xFF3B3B3B);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note Details",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (isChanged) {
              _askToChange();
            } else {
              Navigator.pop(context);
            }
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
              if (isChanged) {
                _updateConfirmation();
              }
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
          SizedBox(width: 10),
        ],
      ),
      body: Consumer<NoteServices>(
        builder: (context, noteServices, child) {
          return NotePage();
        },
      ),
    );
  }

  Widget NotePage() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border:
                  OutlineInputBorder(), // Changed to outline for better visibility
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: null,
            onChanged: (String value) {
              isChanged = true; // Track if text has changed
            },
          ),
          SizedBox(height: 16), // Spacing between fields
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: Theme.of(context).textTheme.bodySmall,
              border:
                  OutlineInputBorder(), // Changed to outline for better visibility
            ),
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: null,
            onChanged: (String value) {
              isChanged = true; // Track if text has changed
            },
          ),
        ],
      ),
    );
  }

  void _updateNote(Note existingNote) {
    try {
      if (_titleController.text != "" && _descriptionController.text != "") {
        // Update the note's properties
        existingNote.title = _titleController.text; // Update title
        existingNote.decription =
            _descriptionController.text; // Update description

        // Call the update method from the NoteService provider
        Provider.of<NoteServices>(context, listen: false).updateNote(
          Provider.of<NoteServices>(context, listen: false)
              .getNoteIndex(existingNote),
          existingNote,
        );
        isChanged = false;
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        if (_titleController.text.isEmpty) {
          _titleController.text = existingNote.title;
        }

        if (_descriptionController.text.isEmpty) {
          _descriptionController.text = existingNote.decription;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('title or description should not be empty')),
        );
        isChanged = true;
        Navigator.pop(context);
      }
      // Pop the screen after saving
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _updateConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SizedBox(
            height: _deviceHeight * 0.35,
            width: _deviceHeight * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Update Task?",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  // Add padding
                  child: Text(
                    "Are you sure you want to update this task? This action cannot be undone.",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
                ConfirmButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _askToChange() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SizedBox(
            height: _deviceHeight * 0.35,
            width: _deviceHeight * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Discard Changes ?",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center, // Center the text
                ),
                DiscardButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget DiscardButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(
            "Yes",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("No", style: Theme.of(context).textTheme.displaySmall),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget ConfirmButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            _updateNote(widget.note);
          },
          child: Text(
            "Yes",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("No", style: Theme.of(context).textTheme.displaySmall),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
