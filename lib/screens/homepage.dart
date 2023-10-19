// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:snake_game/screens/home_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//! Create the Movement of the snake using Enum
enum SnakeMovement { left, right, up, down }

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer player1;
  late AudioPlayer player2;

  @override
  void initState() {
    super.initState();
    player1 = AudioPlayer();
    player2 = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    player1.dispose();
    player2.dispose();
  }

  int _currentscore = 0;

//! Fixed number for the row and the total number or spaces
  final int _rowsize = 10;
  final int _totalnumberofboard = 120;

  //! Declare the food postion for testing
  int foodpos = 63;

  //! Declare the boolean for Game Over
  bool gameover = false;

//! Declare the position of the snake
  List<int> snakepos = [0, 1, 2];

  //! Declare the Movement of the snake using Enum
  SnakeMovement direction = SnakeMovement.right;

  //! Move the Snake
  bool hasgamestarted = false;
  void startgame() async {
    direction = SnakeMovement.right;
    Timer.periodic(Duration(milliseconds: 400), (timer) async {
      setState(() {
        hasgamestarted = true;
        _updatemovement();
        //! to add the Pause and Play Function
        if (_isgamepaused ||
            gameover ||
            didsnakeeatitsbody() ||
            !hasgamestarted) {
          timer.cancel();
        }
      });
      if (gameover) {
        await player1.setAsset('assets/game-over.mp3');
        player1.play();
      }
    });
  }

//! Update the Movement of the Snake to move if you swipe
  void _updatemovement() {
    switch (direction) {
      case SnakeMovement.right:
        if (snakepos.last % _rowsize == 9) {
          gameover = true;
        } else {
          snakepos.add(snakepos.last + 1);
          gameover = false;
        }
        break;
      case SnakeMovement.left:
        if (snakepos.last % _rowsize == 0) {
          gameover = true;
        } else {
          snakepos.add(snakepos.last - 1);
          gameover = false;
        }
        break;
      case SnakeMovement.up:
        if (snakepos.last < _rowsize) {
          gameover = true;
        } else {
          snakepos.add(snakepos.last - _rowsize);
          gameover = false;
        }
        break;
      case SnakeMovement.down:
        if (snakepos.last + _rowsize > _totalnumberofboard) {
          gameover = true;
        } else {
          snakepos.add(snakepos.last + _rowsize);
          gameover = false;
        }
        break;

      default:
    }

    if (snakepos.last == foodpos) {
      eatfood();
    } else {
      snakepos.removeAt(0);
    }
  }

  //! To eat the Food
  void eatfood() async {
    await player2.setAsset('assets/eat-food.mp3');
    player2.play();
    _currentscore++;
    while (snakepos.contains(foodpos)) {
      foodpos = Random().nextInt(_totalnumberofboard);
    }
  }

  //! Declare the boolean for pause and play
  bool _isgamepaused = false;

  //! To Restart and Reset the Game once is has been clicked
  void restartgame() async {
    _isgamepaused = true;

    await showRestartDialog(context, onyestap: () {
      setState(() {
        snakepos = [0, 1, 2];
        _currentscore = 0;
        _isgamepaused = false;
        gameover = false;
        hasgamestarted = false;

        foodpos = Random().nextInt(_totalnumberofboard) + 3;

        Navigator.pop(context);
      });
    });
  }

  //! To check whether the snake hits its own body
  bool didsnakeeatitsbody() {
    List eatsnakebody = snakepos.sublist(0, snakepos.length - 1);
    if (eatsnakebody.contains(snakepos.last)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: Center(
                child: Text(
                  ' Your Score is $_currentscore',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: gameover
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "G A M E O V E R",
                        style: TextStyle(color: Colors.red, fontSize: 30.0),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "YOUR SCORE IS $_currentscore",
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Click the Restart Button to Restart the Game",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      //! Adding Horizontal Movement
                      if (details.delta.dx > 0 &&
                          direction != SnakeMovement.left) {
                        direction = SnakeMovement.right;
                      } else if (details.delta.dx < 0 &&
                          direction != SnakeMovement.right) {
                        direction = SnakeMovement.left;
                      }
                    },
                    onVerticalDragUpdate: (details) {
                      //! Adding Vertical Movement
                      if (details.delta.dy > 0 &&
                          direction != SnakeMovement.up) {
                        direction = SnakeMovement.down;
                      } else if (details.delta.dy < 0 &&
                          direction != SnakeMovement.down) {
                        direction = SnakeMovement.up;
                      }
                    },
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _totalnumberofboard,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _rowsize),
                        itemBuilder: (context, index) {
                          if (foodpos == index) {
                            return reuseablecontainer(color: Colors.green);
                          } else if (snakepos.contains(index)) {
                            return reuseablecontainer(color: Colors.red);
                          } else {
                            return reuseablecontainer(color: Colors.white);
                          }
                        }),
                  ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: Row(
                mainAxisAlignment: gameover
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  gameover
                      ? Container()
                      : bottomactionbutton(context,
                          text: _isgamepaused ? 'Play' : 'Pause', onpress: () {
                          setState(() {
                            _isgamepaused = !_isgamepaused;
                            //! To Continue the game once it is Paused
                            if (!_isgamepaused) {
                              startgame();
                            }
                          });
                        }),
                  bottomactionbutton(context,
                      text: hasgamestarted ? 'Restart' : 'Start', onpress: () {
                    hasgamestarted ? restartgame() : startgame();
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
