import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = 'http://146.190.50.77:81/api/add-user-data';

Future<void> employeeUpdate(String userToken, Map<String, dynamic> postData) async {
  print('User entered data: $postData');

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    },
    body: jsonEncode(postData),
  );

  if (response.statusCode == 201) {
    print('Profile created successfully');
    Fluttertoast.showToast(
      msg: 'Uploaded',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  } else {
    print('Error updating: ${response.body}');
    Fluttertoast.showToast(
      msg: 'Not done',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

class UserUpdate extends StatelessWidget {
  const UserUpdate({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black26,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Please add information into your profile (Do this once)',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Material(
        child: ListView(
          children: <Widget>[
            Image.asset('assets/images/team-solving-problems.png'),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Expanded(child: EmployeeForm()),
            )
          ],
        ),
      ),
    );
  }
}

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({Key? key});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  String? phonenumberError;
  String? dobError;
  String? departmentError;
  String? statusError;
  String? genderError;

  void _submitForm() async {
    final String userToken = await getUserToken();
    if (userToken.isEmpty) {
      print('User token not found');
      return;
    }

    final Map<String, dynamic> postData = {
      'phonenumber': phonenumberController.text,
      'dob': dobController.text,
      'department': departmentController.text,
      'status': statusController.text,
      'gender': genderController.text,
    };

    employeeUpdate(userToken, postData);

    dobController.clear();
    departmentController.clear();
    statusController.clear();
    genderController.clear();
    statusController.clear();
  }

  Future<String> getUserToken() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userToken') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: dobController,
            decoration: InputDecoration(
              labelText: 'Date of birth',
              hintText: 'Enter your dob',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: departmentController,
            decoration: InputDecoration(
              labelText: 'Department',
              hintText: 'Enter department',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: statusController,
            decoration: InputDecoration(
              labelText: 'Employment Status',
              hintText: 'Enter your employment status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: genderController,
            decoration: InputDecoration(
              labelText: 'Gender',
              hintText: 'Gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 30),
          InkWell(
            onTap: _submitForm,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              child: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserUpdate(),
  ));
}
