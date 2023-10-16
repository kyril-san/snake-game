// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

Future showRestartDialog(BuildContext context,
    {required Function()? onyestap}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Restart"),
          content: Text("Are you sure you want to Restart"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: onyestap,
              child: Text('Yes'),
            ),
          ],
        );
      });
}

class Snake {
  final double x;
  final double y;
  const Snake(this.x, this.y);
}

List snakeList = [
  Snake(0, 0),
  Snake(0.01, 0.01),
  Snake(0.02, 0.02),
];
