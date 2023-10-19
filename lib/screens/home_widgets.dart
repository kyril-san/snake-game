import 'package:flutter/material.dart';

Future<void> showRestartDialog(BuildContext context,
    {required Function()? onyestap}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Restart"),
          content: const Text("Are you sure you want to Restart"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: onyestap,
              child: const Text('Yes'),
            ),
          ],
        );
      });
}

bottomactionbutton(BuildContext context,
    {required String text, required Function()? onpress}) {
  return TextButton(
    style: TextButton.styleFrom(
      fixedSize: const Size(90, 20),
      shape: const StadiumBorder(),
      backgroundColor: Colors.white,
    ),
    onPressed: onpress,
    child: Text(text),
  );
}

reuseablecontainer({required Color color}) {
  return Container(
    margin: const EdgeInsets.all(2),
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
          title: const Text("G A M E O V E R"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("YOUR SCORE IS $text"),
              const SizedBox(height: 30),
              const Text("Click the Restart Button to Restart the Game"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: ontap,
              child: const Text('Restart'),
            ),
          ],
        );
      });
}
