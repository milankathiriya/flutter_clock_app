import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String hour = "00";
  String minute = "00";
  String second = "00";
  int hr = 0;
  int min = 0;
  int sec = 0;

  bool isAnalogClock = false;

  void initClock() async {
    Future.delayed(const Duration(seconds: 1), () {
      sec++;

      if (sec == 60) {
        min++;
        sec = 0;
      }
      if (min == 60) {
        hr++;
        min = 0;
      }
      setState(() {
        second = sec.toString();
        minute = min.toString();
        hour = hr.toString();
      });
      initClock();
    });
  }

  @override
  void initState() {
    super.initState();
    initClock();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // BG Layer
          SizedBox(
            height: _height,
            width: _width,
            child: Image.asset(
              "assets/images/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // AppBar
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 25),
              alignment: Alignment.center,
              height: 60,
              width: _width,
              color: Colors.white.withOpacity(0.2),
              child: IconButton(
                icon: Icon(Icons.access_time_rounded),
                onPressed: () {
                  setState(() {
                    isAnalogClock = !isAnalogClock;
                  });
                },
              ),
            ),
          ),
          if (isAnalogClock == false)
            ...DigitalClock(width: _width, height: _height),
          if (isAnalogClock) ...AnalogClock(width: _width, height: _height),
        ],
      ),
    );
  }

  List<Widget> DigitalClock({required double width, required double height}) {
    return [
      // Digital Clock
      Container(
        alignment: Alignment.center,
        height: height * 0.3,
        width: width * 0.65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              offset: Offset(8, 8),
              blurRadius: 50,
              spreadRadius: 5,
              color: Colors.white.withOpacity(0.2),
            ),
          ],
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.grey.withOpacity(0.2),
            ],
          ),
        ),
        child: Text(
          "$hour:$minute:$second",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 20,
            letterSpacing: 5,
          ),
        ),
      ),
      // Indicator
      Transform.scale(
        scale: 2.75,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          color: Colors.amber,
          value: sec / 60,
        ),
      ),
      Transform.scale(
        scale: 3.75,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          color: Colors.redAccent,
          value: min / 60,
        ),
      ),
      Transform.scale(
        scale: 4.75,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          color: Colors.blueAccent,
          value: hr / 60,
        ),
      ),
    ];
  }

  List<Widget> AnalogClock({required double width, required double height}) {
    return [
      Container(
        alignment: Alignment.center,
        height: height * 0.3,
        width: width * 0.65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              offset: Offset(8, 8),
              blurRadius: 50,
              spreadRadius: 5,
              color: Colors.white.withOpacity(0.2),
            ),
          ],
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.grey.withOpacity(0.2),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "$hour:$minute:$second",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 20,
                letterSpacing: 5,
              ),
            ),
            // Hour hand
            Transform.rotate(
              angle: (hr * (2 * pi) / 60) + pi / 2,
              child: Divider(
                color: Colors.blueAccent,
                thickness: 4,
                indent: 45,
                endIndent: 115,
              ),
            ),

            // Minute hand
            Transform.rotate(
              angle: (min * (2 * pi) / 60) + pi / 2,
              child: Divider(
                color: Colors.red,
                thickness: 2.5,
                indent: 30,
                endIndent: 115,
              ),
            ),
            // Second hand
            Transform.rotate(
              angle: (sec * (2 * pi) / 60) + pi / 2,
              child: Divider(
                color: Colors.amber,
                thickness: 1.5,
                indent: 15,
                endIndent: 115,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
