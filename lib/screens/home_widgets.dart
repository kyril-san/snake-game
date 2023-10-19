// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

Future<void> showRestartDialog(BuildContext context,
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

bottomactionbutton(BuildContext context,
    {required String text, required Function()? onpress}) {
  return TextButton(
    style: TextButton.styleFrom(
      fixedSize: Size(90, 20),
      shape: StadiumBorder(),
      backgroundColor: Colors.white,
    ),
    onPressed: onpress,
    child: Text(text),
  );
}

reuseablecontainer({required Color color}) {
  return Container(
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}

Future<void> gameOverDialog(BuildContext context,
    {required Function()? ontap, required String text}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("G A M E O V E R"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("YOUR SCORE IS $text"),
              SizedBox(height: 30),
              Text("Click the Restart Button to Restart the Game"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: ontap,
              child: Text('Restart'),
            ),
          ],
        );
      });
}
