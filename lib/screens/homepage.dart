// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int _countscore = 0;

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
  //* TO START THE GAME
  void _startgame() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      _updategame();
      _didsnakeeatfood();

      checkforgameover();

      if (gameover) {
        timer.cancel();
      }
    });
  }

//* TO UPDATE THE MOVEMENT OF THE GAME
  void _updategame() {
    setState(() {
      if (move == Move.left) {
        snakex -= 0.02;
        // checkforgameover();
      } else if (move == Move.right) {
        snakex += 0.02;
        // checkforgameover();
      } else if (move == Move.up) {
        snakey += 0.01;
        // checkforgameover();
      } else if (move == Move.down) {
        snakey -= 0.01;
        // checkforgameover();
      } else {
        return;
      }
    });
  }

  //* TO CHECK FOR GAME OVER
  bool checkforgameover() {
    if (snakex >= 0.99 || snakex <= -0.99 || snakey >= 1 || snakey <= -1) {
      setState(() {
        gameover = true;
      });
      return true;
    }
    return false;
  }

//* TO SEE IF THE SNAKE EATS THE FOOD
  void _didsnakeeatfood() {
    final finalfoodx = foodx.toStringAsFixed(1);
    final finalfoody = foody.toStringAsFixed(1);
    final finalsnakex = snakex.toStringAsFixed(1);
    final finalsnakey = snakey.toStringAsFixed(1);
    if (finalsnakex == finalfoodx && finalsnakey == finalfoody) {
      setState(() {
        _countscore++;
        foodx = Random().nextDouble() * -0.9;
        foody = Random().nextDouble() * -0.9;
      });
    }
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
            width: MediaQuery.sizeOf(context).width * 1,
            height: MediaQuery.sizeOf(context).height,
            color: Colors.deepPurple[200],
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'The Score is $_countscore',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                gameover
                    ? Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'G A M E O V E R',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 24),
                            ),
                            Text(
                              'FINAL SCORE  IS $_countscore',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ))
                    : Container(),
                Align(
                  alignment: Alignment(snakex, snakey),
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4)),
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
