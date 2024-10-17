import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/Models/Note.dart';
import 'package:myapp/Pages/NoteDetails.dart';
import 'package:provider/provider.dart';

import '../Services/NoteServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Note> noteBox;
  late double _deviceHeight = MediaQuery.of(context).size.height;
  late double _deviceWidth = MediaQuery.of(context).size.width;
  List<Note> _noteList = [];

  void _loadNotes() {
    _noteList = noteBox.values
        .toList(); // Fetch values from the box and convert to List<Note>
    setState(() {}); // Refresh the UI to display the notes
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteBox = Hive.box<Note>('noteList');
    _loadNotes();
    print(noteBox.values);
  }

  @override
  Widget build(BuildContext context) {
    double _buttonSize = 20;
    Color buttonBackgroundColor = Color(0xFF3B3B3B);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
        backgroundColor: buttonBackgroundColor,
      ),
      appBar: AppBar(
        title: Text(
          "Notes",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(
              Icons.search,
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
          ),
          IconButton(
            onPressed: () {
              _showInfo();
            },
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(
              backgroundColor: buttonBackgroundColor,
              fixedSize: Size(_buttonSize, _buttonSize),
              // Example: 100x100 for square
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Border radius of 10px
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Consumer<NoteServices>(
        builder: (context, noteServices, child){
          return  noteServices.notes.isEmpty ? _EmptyScreen() : _listScreen(noteServices.notes);
        },
      ),
    );
  }

  Widget _EmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            'images/background.png',
            width: _deviceHeight * 0.5,
            height: _deviceHeight * 0.5,
          ),
          Text(
            "Create your first note !",
            style: Theme.of(context).textTheme.displaySmall,
          )
        ],
      ),
    );
  }

  Widget _listScreen(List<Note> _noteList) {
    return ListView.builder(
      itemBuilder: (BuildContext _context, int index) {
        var note = _noteList[index];
        return Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(note.colorValue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetails(note: note)));
            },
            child: ListTile(
              title: Text(note.title),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              style: ListTileStyle.list,
            ),
          ),
        );
      },
      itemCount: _noteList.length,
    );
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SizedBox(
            height: _deviceHeight * 0.25,
            width: _deviceHeight * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("- Notify", style: Theme.of(context).textTheme.bodySmall),
                Text("- Created by : Mouhamad Kraytem",
                    style: Theme.of(context).textTheme.bodySmall),
                Text("- Flutter dev",
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        );
      },
    );
  }
}
