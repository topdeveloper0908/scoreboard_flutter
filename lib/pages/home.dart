import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_switch/flutter_switch.dart';


import 'package:scoreboard2/pages/game.dart';
import 'package:scoreboard2/pages/gameMulti.dart';
import 'package:scoreboard2/pages/radio_option.dart';
import 'package:scoreboard2/pages/styles/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  HomePageColors pageColors = HomePageColors();
  HomePageStyles pageStyles = HomePageStyles();
  
  final List<String> items = [
    '2',
    '3',
    '4',
  ];
  int player = 2;
  String players = '2';
  int round = 5;
  int point = 11;
  String matchTitle = 'Game 1';
  bool winbyTwo = false;
  bool winbyServer = false;
  String bestofValue = '5';

  ValueChanged<String?> _bestofValueChangedHandler() {
    return (value) => setState((){
      bestofValue = value!; round = int.parse(value);
      } 
    );
  }
  
  @override
  void initState() {
    getData();
    super.initState();
  }
    
  @override
  void dispose() {
    super.dispose();
  }
  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {  
      player = (prefs.getInt('_player') ?? 2);
      round = (prefs.getInt('_round') ?? 5);
      point = (prefs.getInt('_point') ?? 11);
      matchTitle = (prefs.getString('_matchTitle') ?? 'Game 1');
      winbyTwo = (prefs.getBool('_winbyTwo') ?? false);
      winbyServer = (prefs.getBool('_winbyServer') ?? false);
    });
  }
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('player', player);
    prefs.setInt('round', round);
    prefs.setInt('point', point);
    prefs.setString('matchTitle', matchTitle);
    prefs.setBool('winbyTwo', winbyTwo);
    prefs.setBool('winbyServer', winbyServer);
  }
  Future<void> setDefault() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('_player', player);
    prefs.setInt('_round', round);
    prefs.setInt('_point', point);
    prefs.setString('_matchTitle', matchTitle);
    prefs.setBool('_winbyTwo', winbyTwo);
    prefs.setBool('_winbyServer', winbyServer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: pageColors.mainColor, body: SafeArea(child: Container(child: SingleChildScrollView(child: 
      Column(
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
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scoreboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      )
                ),
                Material(
                    type: MaterialType.transparency,
                  child: Ink(
                      decoration: BoxDecoration(
                          color:  Colors.white,
                          borderRadius: BorderRadius.circular(120.0)), //<-- SEE HERE
                      child: const InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.person,
                            size: 50.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(10,0,10,10),
            decoration:BoxDecoration(  
              color: pageColors.secondColor,
              borderRadius:BorderRadius.circular(8),    
            ),
            child: Column (children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('assets/images/squareball.png', width: 100, height: 100,)
                ])
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child:Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 45,
                            width: 180,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white
                            ),
                            child: Center(
                              child: Text(
                                'Number of players',
                                textAlign: TextAlign.center,
                                style: pageStyles.titleStyle,
                              ),
                            ),
                          ),
                        Container( 
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              buttonPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                              items: items.map((item) =>
                                DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                    ),
                                  ),
                                )).toList(),
                                value: player.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    players = value as String;
                                    player = int.parse(players);
                                  });
                                },
                                buttonHeight: 45,
                                buttonWidth: 60,
                                itemHeight: 40,
                            )
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 180,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white
                            ),
                            child: Center(
                              child: Text(
                                'Best of',
                                textAlign: TextAlign.center,
                                style: pageStyles.titleStyle,
                              ),
                            )
                          ),
                          MyRadioOption<String>(
                            value: '3',
                            groupValue: round.toString(),
                            onChanged: _bestofValueChangedHandler(),
                            label: '1',
                            text: 'of 3',
                          ),
                          MyRadioOption<String>(
                            value: '5',
                            groupValue: round.toString(),
                            onChanged: _bestofValueChangedHandler(),
                            label: '2',
                            text: 'of 5',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 45,
                          width: 180,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Center(
                            child: Text(
                              'Winner Serve',
                              textAlign: TextAlign.center,
                              style: pageStyles.titleStyle,
                            ),
                          )
                        ),
                        FlutterSwitch(
                          width: 80.0,
                          height: 40.0,
                          valueFontSize: 20.0,
                          toggleSize: 33.0,
                          value: winbyServer,
                          borderRadius: 30.0,
                          padding: 5.0,
                          showOnOff: false,
                          activeColor: pageColors.mainColor,
                          onToggle: (val) {
                            setState(() {
                              winbyServer = val;
                            });
                          },
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 45,
                            width: 180,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white
                            ),
                            child: Center(
                              child: Text(
                                'Winner by 2',
                                textAlign: TextAlign.center,
                                style: pageStyles.titleStyle,
                              ),
                            )
                          ),
                          FlutterSwitch(
                            width: 80.0,
                            height: 40.0,
                            valueFontSize: 20.0,
                            toggleSize: 33.0,
                            value: winbyTwo,
                            borderRadius: 30.0,
                            padding: 5.0,
                            showOnOff: false,
                            activeColor: pageColors.mainColor,
                            onToggle: (val) {
                              setState(() {
                                winbyTwo = val;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 45,
                          width: 180,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Center(
                            child: Text(
                              'Game Points',
                              textAlign: TextAlign.center,
                              style: pageStyles.titleStyle,
                            ),
                          )
                        ),
                        SizedBox(
                          width: 100,
                          height: 45,
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                point = int.parse(text);
                              });
                            },
                            keyboardType: const TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              hintText: point.toString(),
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
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            matchTitle = text;
                          });
                        },
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20
                        ),
                        decoration: InputDecoration(
                          hintText: matchTitle,
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20)
                        ),
                      ),
                    ),
                    SizedBox( 
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          padding: const EdgeInsets.fromLTRB(20,10,20,10),
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text(
                          'Start a new Match',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        onPressed: () {
                          saveData();
                          if(player == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>const GamePage()),
                            );
                          }
                          else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>const GamePageMulti()),
                            );
                          }
                        },
                      ),
                    )          
                  ],
                ),
              )
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10, bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    padding: const EdgeInsets.fromLTRB(20,10,20,10),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Save as Default',
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  onPressed: () {
                    setDefault();
                  }
                ),
              )
            ],
          )
         ],
      ),
    ))));
  }
}