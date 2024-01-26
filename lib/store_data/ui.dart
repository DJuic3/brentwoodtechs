import 'dart:convert';
import 'package:brentwoodtechs/store_data/provider.dart';
import 'package:brentwoodtechs/store_data/size_config.dart';
import 'package:brentwoodtechs/store_data/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'button.dart';
import 'input.dart';
import 'package:http/http.dart' as http;
import 'dart:async';



class UserData {
  final String selectedDate;
  final String Dob;
  final String gender;
  final String repeat;
  final String employmentStatus;
  final String phone;


  UserData({
    required this.selectedDate,
    required this.Dob,
    required this.gender,
    required this.repeat,
    required this.employmentStatus,
    required this.phone,

  });

  Map<String, dynamic> toJson() {
    return {
      'selected_date': selectedDate,
      'dob': Dob,
      'gender': gender,
      'repeat': repeat,
      'employment_status': employmentStatus,
      'phone': phone,


    };
  }
}



Future<void> storeUserData(UserData userData) async {

  const apiUrl = 'http://146.190.50.77:81/api/add-user-data';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization: Bearer YOUR_ACCESS_TOKEN'
        'Content-Type': 'application/json',
        'Accept': 'application/json',

      },
      body: jsonEncode(userData.toJson()),
    );

    if (response.statusCode == 200) {
      // Data stored successfully
      print('Data stored successfully');
    } else {
      // Handle errors
      print('Error storing data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Request data: ${jsonEncode(userData.toJson())}');
    }
  } catch (e) {
    // Handle exceptions
    print('Exception: $e');
  }
}

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({Key? key}) : super(key: key);

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isAccountUpdated = false;
  Image? _pickedImage;


  @override
  void initState() {
    super.initState();

    _empstatus = employment[0];
    _gender = genderList[0];
    _areaofwork = '';
    _loadUserData();

  }
  void _loadUserData() {
    final userData = context.read<UserDataModel>();

  }

  Future<void> _getImage() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {

    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Update Information', style: headingStyle),
                
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [const SizedBox(height: 10),

                    Text(
                      'Phone Number',
                      style: subTitleStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),

                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 14),
                      margin: const EdgeInsets.only(top: 8),
                      width: SizeConfig.screenWidth,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter phone number',
                        ),

                          onChanged: (value) {
                            print('Phone Number Changed: $value');
                            context.read<UserDataModel>().phone = value;


                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),



                Row(
                  children: [
                    Expanded(
                      child:
                      InputField(
                        enabled: !context.watch<UserDataModel>().isAccountUpdated,
                        onChanged: (value) {
                          context.read<UserDataModel>().Dob = value;
                        },
                        name: 'Date of birth',
                        hint: DateFormat.yMd().format(_dob),
                        widget: IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _getDetailsFromUser();
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                      InputField(
                        enabled: !context.watch<UserDataModel>().isAccountUpdated,
                        onChanged: (value) {
                          context.read<UserDataModel>().empstatus = value;
                        },
                        name: 'Employment Status',
                        hint: _empstatus,
                        widget: Row(
                          children: [
                            DropdownButton(
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              items: employment.map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(

                                    ),
                                  ),
                                ),
                              ).toList(),
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              iconSize: 32,
                              elevation: 4,
                              underline: Container(height: 0),
                              style: subTitleStyle,
                              value: _selectedEmploymentStatus,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedEmploymentStatus = newValue;
                                  _empstatus= newValue ?? employment[0];
                                });
                              },
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),


                      ),
                    ),
                  ],
                ),

                InputField(
                  enabled: !context.watch<UserDataModel>().isAccountUpdated,
                  onChanged: (value) {
                    context.read<UserDataModel>().gender = value;
                  },
                  name: 'Gender',
                  hint: _gender,
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        items: genderList.map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                // color: Colors.black,
                              ),
                            ),
                          ),
                        ).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        value: _selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                            _gender = newValue ?? genderList[0];
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),

                // Area of work
                InputField(
                  enabled: !context.watch<UserDataModel>().isAccountUpdated,
                  onChanged: (value) {
                    context.read<UserDataModel>().areaofwork = value;
                  },
                  name: 'Department',
                  hint: _areaofwork,
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        items: workList.map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                              ),
                            ),
                          ),
                        ).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        iconSize: 5,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        value: _repeat ,
                        onChanged: (String? newValue) {
                          setState(() {
                            _repeat  = newValue!;
                            _areaofwork = newValue ?? workList[0];
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),




                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // _colorPalette(),
                    MyButton(
                      label: 'Accept',
                      onTap: () {

                        sendUserDataToAPI();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            )
        ),
      ),
    );

  }


  DateTime _selected_date = DateTime.now();
  DateTime _dob = DateTime.now();
  late String _gender;
  String? _selectedGender;
  late String _email;
  late String _name;
  late String _areaofwork;
  late String _repeat = workList[0];
  late String? _selectedEmploymentStatus = employment[0];
  late String _empstatus;
  late String phone;
  List<String> genderList = ['Male', 'Female'];
  List <String> employment = ['Permanent','Part-time','Contract',  ];
  List<String> workList = ["HR","ITS", "Finance", "Risk Management", "Other",
  ];
  final String _searchTerm = "";
  int _selectedColor = 0;



  @override
  void dispose() {
    _nameController.dispose();

    _emailController.dispose();
    super.dispose();
  }

  void sendUserDataToAPI() async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';



    Map<String, dynamic> userData = {
      'selected_date': _selected_date.toString(),
      'dob': _dob.toString(),
      'gender': _gender,
      'department': _areaofwork,
      'repeat': _repeat,
      'status': _selectedEmploymentStatus,
      'empstatus': _empstatus,
      'phonenumber': context.read<UserDataModel>().phone,

    };
    print(userData);

      // Get user token from SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();
      String? userToken = sharedPreferences.getString('userToken');

      if (userToken == null) {
        Fluttertoast.showToast(
          msg: 'User not logged in. Please log in and try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      var apiUrl = 'http://146.190.50.77:81/api/add-user-data';

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json'
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Data sent successfully
        Fluttertoast.showToast(
          msg: 'Account Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        setState(() {
          isAccountUpdated = true;
        });
      } else {
        // Error sending data
        Fluttertoast.showToast(
          msg: 'Failed to Update Account. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Error sending data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }


    _getDetailsFromUser() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1700),
        lastDate: DateTime(2050),
      );
      if (pickedDate != null) {
        setState(() => _dob = pickedDate);
      } else {
        print('It\'s null or something is wrong');
      }
    }



    AppBar _appBar() {
      return AppBar(

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
        ),

        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [

          CircleAvatar(
            backgroundImage: AssetImage('assets/images/landing.png'),
            radius: 18,
          ),
          SizedBox(width: 20),
        ],

      );
    }

    Column _colorPalette() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color', style: nameStyle),
          const SizedBox(height: 8),
          Wrap(
            children: List<Widget>.generate(
              3,
                  (index) =>
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                            ? pinkClr
                            : orangeClr,
                        radius: 14,
                        child: _selectedColor == index
                            ? const Icon(
                            Icons.done, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      );
    }
  }
