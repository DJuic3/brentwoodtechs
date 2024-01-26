import 'dart:convert';
import 'package:brentwood/Screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'employee_details.dart';



class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Logging In'),
            content: CircularProgressIndicator(),
          );
        },
      );

      final response = await http.post(
        Uri.parse('http://146.190.50.77:81/api/login'),
        body: {'email': email, 'password': password},
      );

      // Close loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('token')) {
          final token = responseData['token'];
          print('Login successful');

          // Save the token to SharedPreferences
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('userToken', token);


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeScreen(),
            ),
          );
        } else {
          showErrorMessage(context, 'Server did not return a token.');
        }
      } else if (response.statusCode == 401) {
        showErrorMessage(context, 'Wrong credentials');
      } else {
        showErrorMessage(context, 'Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during login: $e');
      showErrorMessage(context, 'Error during login: $e');
    }
  }
  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> checkExistingToken(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('userToken');

    if (token != null) {
      // Token exists, navigate to HomeScreen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeScreen(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/women-web-developer-with-laptop.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: width * 0.9,
                height: height * 0.3,
                child: Stack(children: [
                ]),
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.08,
                  ),
                  Container(
                    width: width * 0.6,
                    height: height * 0.09,
                    child: Text(
                      "Welcome to Brentwood Technologies",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              SizedBox(
                width: width * 0.9,
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    prefixIcon: Icon(Icons.mail, color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),

              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                width: width * 0.9,
                child: TextFormField(
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _obscureText,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    suffixIcon: GestureDetector(
                      onTap: (() {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {

                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.05,
                  )
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                width: width * 0.9,
                child: ElevatedButton(

                  onPressed: () {
                    loginUser(context, emailController.text, passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 54, 165, 132),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Signup()),
                  );
                },
                child: Text(
                  "Dont have an Account? Register",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
