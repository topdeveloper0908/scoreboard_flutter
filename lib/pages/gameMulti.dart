import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scoreboard2/pages/home.dart';
import 'package:scoreboard2/pages/styles/index.dart';

class GamePageMulti extends StatefulWidget {
  const GamePageMulti({super.key});
  @override
  State<GamePageMulti> createState() => _GamePageMultiState();
}
class _GamePageMultiState extends State<GamePageMulti> {

  HomePageColors pageColors = HomePageColors();
  HomePageStyles pageStyles = HomePageStyles();

  // Timer
  int seconds = 0, minutes = 0, hours = 0;
  late Timer timer;
  bool active = false;
  
  int player = 0;
  int round = 0;
  int currentRound = 1;
  bool endround = false;
  int point = 0;
  String matchTitle = '';
  bool winbyTwo = false;
  bool winbyServer = false;
  int gameStatus = 0; //0-start 1-playing 2-pause 3-end
  String gameStatusText = 'Start Game';
  String dt = DateFormat.yMMMd().format(DateTime.now());

  int serve = 0;

  var playerNames = <String>[];
  var gamePoints=<int>[];

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
      for(int x=0; x<player; x++) {
        gamePoints.add(0);
        playerNames.add('Player $x');
      }
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
                for (int x=0; x<player; x++)...[
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 45,
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              playerNames[x] = text;
                            });
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: playerNames[x],
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
                      Container(
                          width: 75,
                          padding: const EdgeInsets.all(5), 
                          child: Center( child:Text(
                            gamePoints[x].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 45,
                            )
                          )
                        )
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              serve = x;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (serve == x)?Colors.black:Colors.transparent,
                            shape: const StadiumBorder(),
                          ),
                          child: const SizedBox(width: 0),
                        )
                      ),
                      const SizedBox(width: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if(gameStatus == 1 && endround == false) {
                                  if(gamePoints[x] > 0) {
                                    gamePoints[x] = gamePoints[x] - 1;
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              '-',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            )
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if(gameStatus == 1) {
                                  if(endround == false) {
                                    gamePoints[x] = gamePoints[x] + 1;
                                    if(gamePoints[x] > point-1) {
                                      bool isWin=true;
                                      endround=true;
                                      if(winbyTwo) {
                                        for(int y=0;y<player;y++) {
                                          if(x!=y && gamePoints[x]-gamePoints[y]<2) {
                                            isWin = false;
                                          }
                                        }
                                        if(isWin==true) {
                                          if(currentRound >= round) {
                                            gameStatus = 3;
                                            gameStatusText='End Game';
                                            stop();
                                          }
                                        }
                                      }
                                      else {
                                        if(currentRound >= round) {
                                          gameStatus = 3;
                                          gameStatusText='End Game';
                                          stop();
                                        }
                                      }
                                    }
                                    if(winbyServer == true) {
                                      serve = x;
                                    }
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pageColors.mainColor,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              shape: const StadiumBorder()
                            ),
                            child: const Text(
                              '+',
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(10), 
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: 
                  Text(
                    gameStatusText,
                    textAlign: TextAlign.center,
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
                            for(int y=0;y<player;y++) {
                              gamePoints[y]=0;
                            }
                            if(currentRound < round) {
                              currentRound++;
                            } 
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