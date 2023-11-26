import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorCircleAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Generate a random color
    Color randomColor = getRandomColor();

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: randomColor,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
    );
  }

  Color getRandomColor() {
    // Generate a random color with full opacity
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
}
