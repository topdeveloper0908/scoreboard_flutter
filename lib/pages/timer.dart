import 'package:flutter/material.dart';
import 'dart:async';

class MyTimer extends StatefulWidget {
  const MyTimer({Key? key}) : super(key: key);
  increase() => createState().increment();

  @override
  // ignore: library_private_types_in_public_api
  _MyTimerState createState() => _MyTimerState();
}
class _MyTimerState extends State<MyTimer> {
  int seconds = 0, minutes = 0, hours = 0;
  late Timer timer;
  bool active = false;
  int tmp = 0; 

  @override
  void initState() {
    super.initState();
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
    });
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

  @override
  Widget build(BuildContext context) {
    return Text(
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
    );
  }
}
