// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Move { up, down, right, left }

Move move = Move.down;
//* TO RESPAWN THE FOOD AT A DIFFERENT LOCATION
double foodx = Random().nextDouble() * -0.9;
double foody = Random().nextDouble() * -0.9;

//* THE SNAKE MOVEMENTS
double snakex = 0;
double snakey = 0;

//* TO CHECK IF THE GAME IS OVER SO THAT YOU CAN DISPLAY A GAMEOVER PROMPT
bool gameover = false;

class _MyHomePageState extends State<MyHomePage> {
  void _startgame() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      _updategame();

      if (gameover) {
        timer.cancel();
      }
    });
    // _updategame();
  }

  void _updategame() {
    if (move == Move.left) {
      setState(() {
        snakex -= 0.1;
        checkforgameover();
      });
    } else if (move == Move.right) {
      setState(() {
        snakex += 0.1;
        checkforgameover();
      });
    } else if (move == Move.up) {
      setState(() {
        snakey += 0.1;
        checkforgameover();
      });
    } else if (move == Move.down) {
      setState(() {
        snakey -= 0.1;
        checkforgameover();
      });
    }
  }

  bool checkforgameover() {
    if (snakex >= 0.9 || snakex <= -0.9 || snakey >= 0.9 || snakey <= -0.9) {
      setState(() {
        gameover = true;
      });
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _startgame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx <= -1.0) {
              setState(() {
                move = Move.left;
              });
            } else if (details.delta.dx >= 1.0) {
              setState(() {
                move = Move.right;
              });
            }
          },
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -0.5) {
              setState(() {
                move = Move.down;
              });
            } else if (details.delta.dy > 0.5) {
              setState(() {
                move = Move.up;
              });
            }
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            color: Colors.deepPurple[200],
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(snakex, snakey),
                  child: Container(
                    height: 30,
                    width: 20,
                    color: Colors.red,
                  ),
                ),
                Align(
                  alignment: Alignment(foodx, foody),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
