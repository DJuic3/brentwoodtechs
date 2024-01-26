import 'dart:convert';
import 'dart:ui';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../auth/login.dart';
import '../contributions/landingpage.dart';
import '../contributions/mycontributions.dart';
import '../contributions/view.dart';
import '../others/leave_page.dart';
import '../others/meeting_cart.dart';
import '../profile/profile.dart';
import '../store_data/accouncontroller.dart';
import '../store_data/ui.dart';
import 'employeeList.dart';
import 'employeeUpdate.dart';




class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late final int userId;

  String name = "";
  String email = "";
  String department = "";
  String id = "";
  String dob ='';
  String phonenumber ='';
  String status ='';
  String gender ='';
  final DateTime _selectedDate = DateTime.now();
  final AccountController _accountController = Get.put(AccountController());


  @override
  void initState() {

    super.initState();
    _fetchUserDetails();
  }



  Future<void> _handleRefresh() async {
    await _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      final userToken = sharedPreferences.getString('userToken');

      if (userToken == null) {
        print('User token not found');
        return;
      }

      final response = await http.get(
        Uri.parse('http://146.190.50.77:81/api/get-user-data'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        setState(() {
          email = responseData['email'];
          name = responseData['name'];
          gender = responseData['gender'];
          status = responseData['status'];
          dob = responseData['dob'];
          phonenumber = responseData['phone'];
          department = responseData['repeat'];
          id = responseData['id'];

        });
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Brentwood Technologies'),
          content: const Text(
            'Welcome to Brentwood Technologies, '
                '    is a cutting-edge technology company at the '
                'forefront of innovation, dedicated to '
                'transforming the digital landscape.'
                ' Established in 2010, Brentwood has quickly emerged'
                ' as a leader in providing solutions that '
                ' empower businesses and individuals to thrive '
                'in the ever-evolving digital era.',
            style: TextStyle(fontSize: 10),),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> logoutUser(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Logging Out'),
            // content: CircularProgressIndicator(),
            content: SizedBox(
              width: 0.5, // Set your desired width
              height: 0.5, // Set your desired height
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('userToken');

      if (token != null) {
        final response = await http.post(
          Uri.parse('http://146.190.50.77:81/api/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );


        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          print('Logout successful');


          sharedPreferences.remove('userToken');


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  LoginPage(),
            ),
          );
        } else {
          showErrorMessage(context, 'Logout failed: ${response.reasonPhrase}');
        }
      } else {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmployeeScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      showErrorMessage(context, 'Error during logout: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.09),
        child: AppBar(
          leading: Container(
              margin: EdgeInsets.only(top: height * 0.01, left: width * 0.01),
              child: Image.asset("assets/images/1.png")),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Container(
              width: width * 0.50,
              height: height * 0.8,
              margin: EdgeInsets.only(top: height * 0.008),
              child: Image.asset(
                "assets/images/mini.png",
              )),
        ),

      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(

              accountName: const Text('BRENTWOOD TECHNOLOGIES'),
              accountEmail: FutureBuilder<Map<String, String?>>(
                future: getUserDetails(context),
                builder: (BuildContext context, AsyncSnapshot<Map<String, String?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final email = snapshot.data?['email'] ?? 'Anonymous';
                    final name = snapshot.data?['name'] ?? 'Anonymous';
                    return Column(
                      children: [

                        Text(
                          'Welcome $name',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),

              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Staff'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  const UserListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.free_cancellation),
              title: const Text('Leave'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  const LeaveScreen()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                _showHelpDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Add Contributions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddContribution()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Staff Contributions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FinanceTableScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('My Contributions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContributionsTable()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                logoutUser(context);
              },
            ),


          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: height,
            width: width,
            child: Stack(

              children: [

                Container(
                  height: height * 0.25,
                  width: width * 0.9,
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      border: (Border.all(width: 0.1, color: Colors.white)),
                      borderRadius:
                      const BorderRadius.all(const Radius.circular(30.0)),
                      color: Color.fromARGB(255, 246, 248, 216),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 209, 200, 200),
                            spreadRadius: 3.0,
                            blurRadius: 5.0,
                            blurStyle: BlurStyle.normal),
                      ]),
                  child: Column(
                    children: [

                      SizedBox(
                        height: 5,
                        width: 10,
                      ),
                      Text(
                        "Monthly overview",
                        style: TextStyle(color: Color.fromARGB(255, 196, 193, 193)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: height * 0.1,
                  left: width * 0.11,
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: height * 0.03,
                        animation: true,
                        animationDuration: 1200,
                        lineWidth: width * 0.015,
                        percent: 0.8,
                        center: new Text(
                          "10h",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        progressColor: Color.fromARGB(255, 121, 192, 74),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        "Over Time",
                        style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: height * 0.1,
                  right: width * 0.1,
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: height * 0.03,
                        animation: true,
                        animationDuration: 1200,
                        lineWidth: width * 0.015,
                        percent: 0.7,
                        center: new Text(
                          "7",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        progressColor: Color.fromARGB(255, 255, 61, 61),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        "Leave",
                        style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: height * 0.28,
                    child: Container(
                      height: height * 0.4,
                      width: width * 0.9,
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: (Border.all(width: 0.1, color: Colors.white)),
                          borderRadius:
                          const BorderRadius.all(const Radius.circular(20.0)),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 209, 200, 200),
                                spreadRadius: 3.0,
                                blurRadius: 5.0,
                                blurStyle: BlurStyle.normal),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.07,
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: height * 0.001,
                          ),
                          Text(
                            email,
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Color.fromARGB(255, 133, 132, 132)),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "EMPLOYEE  ID:",
                                style: TextStyle(
                                    fontSize: 13.0, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                department,
                                style: TextStyle(
                                    fontSize: 13.0, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.badge,
                              ),
                              SizedBox(
                                width: width * 0.020,
                              ),
                              Text(
                                department,
                                style: TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          SizedBox(
                            height: height * 0.04,
                            width: width * 0.40,


                            child: ElevatedButton(
                              onPressed: () async {
                                await Get.to(() => const AddAccountPage());
                                _accountController.getAccounts();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 13, 22, 31),
                                ),
                              ),
                              child: Text(
                                "Update Account",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                    )),
                Positioned(
                  top: height * 0.75,
                  left: width * 0.025,
                  child: Container(
                    height: height * 0.080,
                    width: width * 0.95,
                    decoration: BoxDecoration(
                      border: (Border.all(
                          width: 0.1, color: Color.fromARGB(255, 0, 0, 0))),
                      borderRadius:
                      const BorderRadius.all(const Radius.circular(50.0)),
                      color: Colors.white,
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MeetingCart()),
                          );
                        },
                        child: SizedBox(
                            width: width * 0.2,
                            height: height * 0.13,
                            child: Image.asset("assets/images/feedbackImage.png")),
                      ),
                      SizedBox(
                        width: width * 0.4,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {

                        },
                        child: SizedBox(
                            width: width * 0.2,
                            height: height * 0.13,
                            child: Image.asset("assets/images/feedbackImage.png")),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      )
                    ]),
                  ),
                ),
                Positioned(
                  top: height * 0.72,
                  left: width * 0.44,
                  child: RotationTransition(
                    turns: new AlwaysStoppedAnimation(-0 / 360),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          border: Border.all(
                              width: 1.0,
                              color: Color.fromARGB(255, 235, 241, 236)),
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      width: 60.0,
                      height: 60.0,
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.73,
                  left: width * 0.41,
                  child: TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () {},
                    child: Image.asset("assets/images/circle.png"),
                  ),
                ),

                Positioned(
                    top: height * 0.24,
                    left: width * 0.33,
                    child: SizedBox(
                      height: height * 0.15,
                      child: Container(
                        child: CircleAvatar(
                            radius: width * 0.18,
                            backgroundImage: AssetImage("assets/images/data.png")),
                      ),
                    )),
              ],
            ),
          ),
        ),

      ),
    );

  }

  Future<Map<String, String?>> getUserDetails(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch the user token from shared preferences
    final userToken = prefs.getString('userToken');

    if (userToken == null) {
      // Token not found, handle the case accordingly
      return {'email': null, 'name': null};
    }

    const apiUrl = 'http://146.190.50.77:81/api/user-details';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON and extract the user email and name
        final Map<String, dynamic> data = json.decode(response.body);
        final String? email = data['email'];
        final String? name = data['name'];

        return {'email': email, 'name': name};
      } else {
        // Handle error cases
        print('Failed to load user details: ${response.statusCode}');
        return {'email': null, 'name': null};
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching user details: $e');
      return {'email': null, 'name': null};
    }
  }
  Future<String> getUserToken() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userToken') ?? '';
  }

  void main() {
    runApp(const GetMaterialApp(
      home: UserUpdate(),
    ));
  }

}