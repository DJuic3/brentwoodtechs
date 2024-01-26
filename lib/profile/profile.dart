import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  String email = '';
  String name = '';
  String gender = '';
  String department = '';
  String dob = '';
  String phonenumber = '';


  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
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

        setState(() {
          email = responseData['email'] ?? 'Not completed';
          name = responseData['name'] ?? 'Not completed';
          gender = responseData['gender'] ?? 'Not completed';
          department = responseData['department'] ?? 'Not completed';
          dob = responseData['dob'] ?? 'Not completed';
          phonenumber = responseData['phonenumber'] ?? 'Not completed';
        });
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
  Future<void> _refreshPage() async {

    await Future.delayed(const Duration(seconds: 2));

    // Set the state to rebuild the UI with the updated data
    setState(() {
      // Update your data variables here
      name = 'Updated Name';
      gender = 'Updated Gender';
      // status = 'Updated Status';
      department = 'Updated Department';
      dob = 'Updated Dob';
      phonenumber = 'Updated Phone';

    });
  }
  Future<void> _refreshDetails() async {
    await _fetchUserDetails();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          elevation: 0,
          backgroundColor: Colors.white,

          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.grey[700],
              size: 18,
            ),
          ),


        ),

        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () => _refreshDetails(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0),
                      child: Text(
                        'Profile Details',
                        style: GoogleFonts.lato(
                            color: Colors.grey[800],
                            fontSize: 26,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          // color: Colors.orange,
                            borderRadius: BorderRadius.all(Radius.circular(40))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 13, right: 20, top: 10, bottom: 10),
                          child: Row(
                            children: [

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 180,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            height: 108,
                            width: 101,
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 25, bottom: 5),
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(140)),
                            child:  CircleAvatar(
                              child: Image.asset(
                                'assets/images/data.png', // Replace with your actual asset path

                              ),
                            )
                        ),
                        Positioned(
                          bottom: 54,
                          right: 20,
                          child: Material(
                              color: Colors.blue[900],
                              elevation: 10,
                              borderRadius: BorderRadius.circular(100),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.zoom_out_map,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildUserInformation('Name', name),
                _buildUserInformation('Gender', gender),
                // _buildUserInformation('Status', status),
                _buildUserInformation('Department', department),

                const SizedBox(height: 20),

                _buildSectionHeader('Personal Information'),
                _buildPersonalInformation('Date of birth', dob),
                _buildPersonalInformation('Phone Number', phonenumber),

              ],
            ),
          ),
        )
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Icon(Icons.person),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: GoogleFonts.lato(
              color: Colors.grey[700],
              fontSize: 17,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInformation(String title, String? value) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              '$title ',
              style: GoogleFonts.lato(
                color: Colors.grey[900],
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 37.0),
            child: Text(
              '   ${value ?? 'NA'}', // Use 'NA' if value is null
              style: GoogleFonts.lato(
                color: Colors.grey[600],
                fontSize: 14,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPersonalInformation(String title, String value) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 54.0),
            child: Icon(Icons.work, color: Colors.grey[500]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Display the title
                  style: GoogleFonts.lato(
                    color: Colors.grey[500],
                    fontSize: 12,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  value.isNotEmpty ? value : 'NA', // Use 'NA' if value is empty
                  style: GoogleFonts.lato(
                    color: Colors.grey[700],
                    fontSize: 14,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}



