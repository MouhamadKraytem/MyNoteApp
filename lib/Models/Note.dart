import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'Note.g.dart';

List<int> availableColors = [
  Colors.red.value,
  Colors.pink.value,
  Colors.purple.value,
  Colors.deepPurple.value,
  Colors.indigo.value,
  Colors.blue.value,
  Colors.lightBlue.value,
  Colors.cyan.value,
  Colors.teal.value,
  Colors.green.value,
  Colors.lightGreen.value,
  Colors.lime.value,
  Colors.yellow.value,
  Colors.amber.value,
  Colors.orange.value,
  Colors.deepOrange.value,
  Colors.brown.value,
  Colors.grey.value,
  Colors.blueGrey.value,
];
@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String decription;

  @HiveField(2)
  int colorValue =getRandomColorValue();


  // Constructor
  Note({
    required this.title,
    required this.decription,
  });

  // Getter for color
  Color get color => Color(colorValue);

  // Setter for color
  set color(Color color) => colorValue = color.value;

  static int getRandomColorValue() {
    Random random = Random();
    return availableColors[random.nextInt(availableColors.length)];
  }
}