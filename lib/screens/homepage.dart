// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snake_game/screens/home_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int _countscore = 0;
double height = 5;

enum Move { up, down, right, left }

Move move = Move.down;

//* TO RESPAWN THE FOOD AT A DIFFERENT LOCATION
double foodx = Random().nextDouble() * -0.9;
double foody = Random().nextDouble() * -0.9;

//* THE SNAKE MOVEMENTS
double snakex = 0;
double snakey = 0;

//* TO CHECK IF THE GAME IS OVER OR PAUSEDSO THAT YOU CAN DISPLAY A GAMEOVER PROMPT
bool gameover = false;
bool ispaused = false;
bool hasgameStarted = false;
bool isvertical = false;

class _MyHomePageState extends State<MyHomePage> {
  //* TO START THE GAME
  void _startgame() {
    Timer.periodic(Duration(milliseconds: 100), (timer) async {
      _updategame();
      _didsnakeeatfood();

      checkforgameover();

      if (gameover || ispaused) {
        timer.cancel();
      } else {
        timer.isActive;
      }
    });
  }

  void restart() {
    setState(() {
      _startgame();
    });
  }

//* TO UPDATE THE MOVEMENT OF THE GAME
  void _updategame() {
    setState(() {
      if (move == Move.left) {
        // snakeList.removeLast();
        snakex -= 0.02;
        isvertical = false;
        // snakeList.first = snakex;
        // snakeList.add(0.01);
        // checkforgameover();
      } else if (move == Move.right) {
        snakex += 0.02;
        isvertical = false;
        // checkforgameover();
      } else if (move == Move.up) {
        snakey += 0.01;
        isvertical = true;
        // checkforgameover();
      } else if (move == Move.down) {
        snakey -= 0.01;
        isvertical = true;
        // checkforgameover();
      } else {
        return;
      }
    });
  }

  //* TO CHECK FOR GAME OVER
  void checkforgameover() {
    if (snakex >= 1 || snakex <= -1 || snakey >= 1 || snakey <= -1) {
      setState(() {
        gameover = true;
      });
    } else {
      gameover = false;
    }
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
        height += 15;
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

//* THE WIDGET BUILDER
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'The Score is $_countscore',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                )),
          ),
          GestureDetector(
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
              width: MediaQuery.sizeOf(context).width * 0.95,
              height: MediaQuery.sizeOf(context).height * 0.85,
              color: Colors.deepPurple[200],
              child: hasgameStarted
                  ? Stack(
                      children: [
                        gameover
                            ? Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'G A M E O V E R',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 24),
                                    ),
                                    Text(
                                      'FINAL SCORE  IS $_countscore',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ))
                            : Container(),
                        //! Snake
                        gameover
                            ? Container()
                            // : ListView.builder(
                            //     scrollDirection: Axis.vertical,
                            //     shrinkWrap: true,
                            //     clipBehavior: Clip.none,
                            //     itemCount: snakeList.length,
                            //     itemBuilder: (context, index) {
                            //       final snakebody = snakeList;
                            //       if (snakebody.contains(index)) {
                            : Align(
                                alignment: Alignment(snakex, snakey),
                                child: Container(
                                  height: isvertical ? height : 5,
                                  width: isvertical ? 5 : height,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                        //! Food
                        gameover
                            ? Container()
                            : Align(
                                alignment: Alignment(foodx, foody),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                ),
                              )
                      ],
                    )
                  : Center(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              hasgameStarted = true;
                              _startgame();
                            });
                          },
                          child: Text(
                            'C L I C K  H E R E  T O  S T A R T',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    setState(() {
                      ispaused = !ispaused;
                      _startgame();
                    });
                  },
                  child: Text(ispaused ? 'Play' : 'Pause'),
                ),
                SizedBox(width: 20),
                gameover
                    ? TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () async {
                          await showRestartDialog(
                            context,
                            onyestap: () {
                              setState(() {
                                _countscore = 0;
                                snakex = 0;
                                snakey = 0;
                                gameover = false;
                                height = 5;

                                hasgameStarted = false;
                                Navigator.pop(context);
                              });
                            },
                          );
                        },
                        child: Text('Restart'),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
