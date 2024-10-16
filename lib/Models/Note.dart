import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String decription;

  @HiveField(2)
  int colorValue = Colors.blueGrey.value;

  // Constructor
  Note({
    required this.title,
    required this.decription,
  });

  // Getter for color
  Color get color => Color(colorValue);

  // Setter for color
  set color(Color color) => colorValue = color.value;

}