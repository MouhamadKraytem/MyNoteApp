import 'package:flutter/material.dart';
import 'package:myapp/Pages/NoteDetails.dart';
import 'package:provider/provider.dart';

import 'Models/Note.dart';
import 'Pages/HomePage.dart';
import 'Pages/AddNote.dart';
import 'Pages/SearchPage.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Services/NoteServices.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  NoteServices noteService = NoteServices();
  await noteService.initializeBox();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => noteService),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/add' : (context) => AddNote(),
        '/search' : (context) => SearchPage(),
      },
      theme: ThemeData(
        textTheme: TextTheme(
          displayMedium: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),bodyMedium: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF252525)),
        scaffoldBackgroundColor: Color(0xFF252525),
        dialogBackgroundColor: Color(0xFF3E3B3B),
      ),
      title: 'Note App',
      debugShowCheckedModeBanner: false,
    );
  }
}
