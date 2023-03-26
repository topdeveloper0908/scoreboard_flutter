import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scoreboard2/pages/home.dart';
import 'package:scoreboard2/pages/timer.dart';
import 'package:scoreboard2/pages/styles/index.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}
class _GamePageState extends State<GamePage> {

  HomePageColors pageColors = HomePageColors();
  HomePageStyles pageStyles = HomePageStyles();

  // Timer
  int seconds = 0, minutes = 0, hours = 0;
  late Timer timer;
  bool active = false;

  int player = 0;
  int round = 0;
  int point = 0;
  String matchTitle = '';
  bool winbyTwo = false;
  bool winbyServer = false;
  int currentRound = 1;
  bool endround = false;
  int wins = 0;
  int wins_2 = 0;
  bool playerSide = false; // Player1-false Player2-true
  int gameStatus = 0; //0-start 1-playing 2-pause 3-end
  String gameStatusText = 'Start Game';
  String dt = DateFormat.yMMMd().format(DateTime.now());

  int serve = 0;

  List<String> playerNames = ['Player 1', 'Player 2'];
  List<List<int>> gamePoints = [[0,0], [-1,-1], [-1,-1], [-1,-1], [-1,-1]];


  @override
  void initState() {
    super.initState();
    getData();
  }
    
  @override
  void dispose() {
    super.dispose();
  }

  void stop() {
    timer.cancel();
    setState(() {
      active = false;
    });
  }

  void reset() {
    timer.cancel();
      setState(() {
        seconds = 0;
        minutes = 0;
        hours = 0;
        active = false;
      }
    );
  }
  void increment() {
    setState(() {
      active = true;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;
      if (localSeconds > 60) {
        localMinutes++;
        if (localMinutes > 60) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        this.timer = timer;
      });
    });
  }


  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      player = (prefs.getInt('player') ?? 2);
      round = (prefs.getInt('round') ?? 5);
      point = (prefs.getInt('point') ?? 11);
      matchTitle = (prefs.getString('matchTitle') ?? 'Game 1');
      winbyTwo = (prefs.getBool('winbyTwo') ?? false);
      winbyServer = (prefs.getBool('winbyServer') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: pageColors.mainColor, body: SafeArea(child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            decoration: BoxDecoration(
              color: pageColors.secondColor
            ),
            child: const Text(
              'Squash scoreboard SQ55',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              )
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(
                    matchTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    )
                  )),
                  Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 0), child: Text(
                    'Date: $dt',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    )
                  )),
                ],
              ),
              Image.asset('assets/images/squareball.png', width: 100, height: 100,)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 10), child: Text(
                    'Time: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    )
                  )),
                  Text(
                    '${(hours >= 10) ? '$hours' : '0${hours}'}:${(minutes >= 10)
                            ? '${minutes}'
                            : '0${minutes}'}:${(seconds >= 10)
                            ? '${seconds}'
                            : '0${seconds}'}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 251, 228, 228),
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(gameStatus == 0) {
                          gameStatus = 1;
                          gameStatusText = 'Playing...';
                          increment();
                        }
                        else if(gameStatus == 1) {
                          gameStatus = 2;
                          gameStatusText = 'Pause...';
                          stop();
                        }
                        else if(gameStatus == 2) {
                          gameStatus = 1;
                          gameStatusText = 'Playing...';
                          increment();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0),
                      shadowColor: Colors.transparent
                    ),
                    child: Icon(
                      (gameStatus == 1)?Icons.pause:Icons.play_arrow,
                      color: Colors.white,
                      size: 60,
                    )
                  )
                ]
              ),
              Padding(padding: const EdgeInsets.only(right: 10), child: Text(
                'Game $currentRound ',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                )
              ))
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10,0,10,10),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: pageColors.secondColor,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 45,
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  playerNames[0] = text;
                                });
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: playerNames[0],
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    color: Colors.white
                                  )
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white
                                  )
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: pageColors.mainColor
                                  )
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10)
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10), child: Text(
                            (gamePoints[currentRound-1][0] == -1) ?'0': gamePoints[currentRound-1][0].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 60,
                            )
                          )),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        serve = 0;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: (serve == 0)?Colors.black:Colors.transparent,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const SizedBox(width: 0),
                                  )
                                ),
                                SizedBox(
                                  width: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        playerSide = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shadowColor: Colors.transparent
                                    ),
                                    child: Text(
                                      'L',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: (playerSide == false && serve ==0)?Colors.black:Colors.grey
                                      ),
                                    )
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        playerSide = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shadowColor: Colors.transparent
                                    ),
                                    child: Text(
                                      'R',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: (playerSide == true && serve == 0)?Colors.black:Colors.grey
                                      ),
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if(gameStatus == 1) {
                                      if(endround == false) {
                                        gamePoints[currentRound-1][0] = gamePoints[currentRound-1][0] + 1;
                                        playerSide = !playerSide;
                                        if(winbyServer == true) {
                                          serve = 0;
                                        }
                                        if(gamePoints[currentRound-1][0] > point-1) {
                                          if( winbyTwo == true) {
                                            if(gamePoints[currentRound-1][0] - gamePoints[currentRound-1][1]>1){
                                              if(gamePoints[currentRound-1][0] > gamePoints[currentRound-1][1]) {
                                                wins++;
                                              }
                                              if(wins > round/2 || (currentRound-wins-1) > round/2) {
                                                gameStatus = 3;
                                                gameStatusText = "End Game";
                                                stop();
                                              }
                                              else {
                                                gamePoints[currentRound-1][0] = gamePoints[currentRound-1][0] - 1;
                                              }
                                            }
                                          }
                                          else {
                                            if(gamePoints[currentRound-1][0] > gamePoints[currentRound-1][1]) {
                                              wins++;
                                            }
                                            if(wins > round/2 || (currentRound-wins-1) > round/2) {
                                              gameStatus = 3;
                                              gameStatusText = "End Game";
                                              stop();
                                            }
                                            else {
                                              endround = true;
                                            }
                                          }
                                        }
                                      }
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pageColors.mainColor,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                  shape: const StadiumBorder()
                                ),
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 50,
                                  ),
                                )
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if(gameStatus == 1 && endround==false) {
                                      if(gamePoints[currentRound-1][0] > 0) {
                                        gamePoints[currentRound-1][0] = gamePoints[currentRound-1][0] - 1;
                                      }
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                                  shape: const StadiumBorder()
                                ),
                                child: const Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                )
                              )
                            ],)
                        ],
                      )
                    ),
                    Container(
                      width: 2,
                      height: 270,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: const Text(
                        ''
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 45,
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  playerNames[1] = text;
                                });
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: playerNames[1],
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    color: Colors.white
                                  )
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white
                                  )
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: pageColors.mainColor
                                  )
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10)
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(10), child: Text(
                            (gamePoints[currentRound-1][1] == -1) ?'0': gamePoints[currentRound-1][1].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 60,
                            )
                          )),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        serve = 1;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: (serve == 1)?Colors.black:Colors.transparent,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const SizedBox(width: 0),
                                  )
                                ),
                                SizedBox(
                                  width: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        playerSide = true;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shadowColor: Colors.transparent
                                    ),
                                    child: Text(
                                      'L',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: (playerSide == false && serve == 1)?Colors.white:Colors.grey
                                      ),
                                    )
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        playerSide = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.transparent,
                                      padding: const EdgeInsets.all(0),
                                      shadowColor: Colors.transparent
                                    ),
                                    child: Text(
                                      'R',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: (playerSide == true && serve == 1)?Colors.white:Colors.grey
                                      ),
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if(gameStatus == 1 && endround == false) {
                                      if(gamePoints[currentRound-1][1] > 0) {
                                        gamePoints[currentRound-1][1] = gamePoints[currentRound-1][1] - 1;
                                      }
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                  shape: const StadiumBorder()
                                ),
                                child: const Text(
                                  '-',
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                )
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if(gameStatus == 1) {
                                      if(endround == false) {
                                        gamePoints[currentRound-1][1] = gamePoints[currentRound-1][1] + 1;
                                        playerSide = !playerSide;
                                        if(winbyServer == true) {
                                          serve = 1;
                                        }
                                        if(gamePoints[currentRound-1][1] > point-1) {
                                          if( winbyTwo == true) {
                                            if(gamePoints[currentRound-1][1] - gamePoints[currentRound-1][0]>1){
                                              if(gamePoints[currentRound-1][1] > gamePoints[currentRound-1][0]) {
                                                wins_2++;
                                              }
                                              if(wins_2 > round/2 || (currentRound-wins_2-1) > round/2) {
                                                gameStatus = 3;
                                                gameStatusText = "End Game";
                                                stop();
                                              }
                                              else {
                                                gamePoints[currentRound-1][1] = gamePoints[currentRound-1][1] - 1;
                                              }
                                            }
                                          }
                                          else {
                                            if(gamePoints[currentRound-1][1] > gamePoints[currentRound-1][0]) {
                                              wins_2++;
                                            }
                                            if(wins_2 > round/2 || (currentRound-wins_2-1) > round/2) {
                                              gameStatus = 3;
                                              gameStatusText = "End Game";
                                              stop();
                                            }
                                            else {
                                              endround = true;
                                            }
                                          }
                                        }
                                      }
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pageColors.mainColor,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                  shape: const StadiumBorder()
                                ),
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 50,
                                  ),
                                )
                              ),
                            ],)
                        ],
                      )
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10), 
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    gameStatusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                    )
                  )
                )
              ],
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(10), 
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                        playerNames[0],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        )
                      )
                    ),
                    for(int x = 1; x <= round; x++)...[
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 5), 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Center(child:Text(
                          (gamePoints[x-1][0] == -1) ?'': gamePoints[x-1][0].toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          )
                        ))
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(vertical:5, horizontal: 15), 
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: pageColors.mainColor,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                        wins.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800
                        )
                      )
                    ),
                  ]
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(10), 
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                        playerNames[1],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        )
                      )
                    ),
                    for(int x = 1; x <= round; x++)...[
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 5), 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Center(child:Text(
                          (gamePoints[x-1][1] == -1) ?'': gamePoints[x-1][1].toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          )
                        ))
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(vertical:5, horizontal: 15), 
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: pageColors.mainColor,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                        wins_2.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800
                        )
                      )
                    ),
                  ]
                ),
              ]
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    '$player Players - ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )
                  ),
                  Text(
                    'Best of $round - ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )
                  ),
                  Text(
                    '$point Points',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )
                  )
                ],
              ),
             ),
             Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {                  
                      if(endround == true) {
                        setState(() {
                          if(gameStatus != 4) {
                            currentRound++;
                            gamePoints[currentRound-1][0] = 0;
                            gamePoints[currentRound-1][1] = 0;
                            endround = false;
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: const Icon(
                      Icons.restart_alt,
                      color: Colors.black,
                      size: 30,
                    )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                      ),
                    )
                  ),
                )
              ],
             )
            ],
          )
        ]
      )
    )));
  }
}