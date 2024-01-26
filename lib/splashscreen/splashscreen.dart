import 'dart:async';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:brentwood/Screens/login_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 135, 197),
      body: Container(
        height: height,
        width: width,
        child: Stack(children: [
          Container(
            height: height * 0.5,
            width: width * 1.0,
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
            ),
          ),

        ]),
      ),
    );
  }
}
