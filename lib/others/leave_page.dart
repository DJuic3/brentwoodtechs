import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:brentwood/Screens/success_page.dart';
import 'package:intl/intl.dart';



class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  var isSwitched;
  DateTime? sdate;
  DateTime? edate;
  final dateFormate = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.035,
                ),
                SizedBox(
                  width: width * 0.16,
                  height: height * 0.07,
                  child: Container(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 236, 235, 235),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  width: width * 0.15,
                ),
                Text(
                  "Leave Request",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.05,
                ),
                Text(
                  "Leave Reason",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ],
            ),
            Container(
              width: width * 0.9,
              height: height * 0.06,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: (Border.all(
                    width: 0.1, color: Color.fromARGB(255, 179, 175, 175))),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(25.0)),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  decoration: new InputDecoration.collapsed(
                    hintText: "Please provide a summary of your request",
                    hintStyle: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),

            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Half day :",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
                Switch(
                  value: isSwitched ?? true,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      print(isSwitched);
                    });
                  },
                  activeTrackColor: Color.fromARGB(255, 23, 145, 50),
                  activeColor: Color.fromARGB(255, 249, 255, 249),
                ),
                SizedBox(width: width * 0.05),
              ],
            ),
            SizedBox(height: height * 0.5),
            Container(
              height: height * 0.09,
              width: width * 0.8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 214, 213, 213),
                      spreadRadius: 2.0,
                      blurRadius: 5.0,
                      blurStyle: BlurStyle.normal),
                ],
                border: (Border.all(
                    width: 0.1, color: Color.fromARGB(255, 255, 255, 255))),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(50.0)),
                color: Colors.white,
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    width: width * 0.4,
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: "Write a message...",
                        border: InputBorder.none,
                      ),
                    )),
                SizedBox(
                  width: width * 0.05,
                ),
                RotationTransition(
                  turns: new AlwaysStoppedAnimation(-0 / 360),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                            width: 1.0,
                            color: Color.fromARGB(255, 235, 241, 236)),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    width: width * 0.16,
                    height: height * 0.07,
                    child: TextButton(
                      style: TextButton.styleFrom(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SuccessScreen()));
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      )),
    );
  }
}
