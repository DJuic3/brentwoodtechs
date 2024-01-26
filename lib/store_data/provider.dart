import 'package:flutter/material.dart';


class UserDataModel extends ChangeNotifier {

  DateTime _selectedDate = DateTime.now();
  DateTime _dob = DateTime.now();
  String _gender = '';
  String _phone = '';
  String _empstatus = '';
  String _areaofwork = '';
  String _repeat = '';



  DateTime get selectedDate => _selectedDate;
  DateTime get Dob => _dob;
  String get gender => _gender;
  String get phone => _phone;
  String get empstatus => _empstatus;
  String get areaofwork => _areaofwork;
  String get repeat => _repeat;



  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  set Dob(DateTime value) {
    _dob = value;
    notifyListeners();
  }

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  set empstatus(String value) {
    _empstatus = value;
    notifyListeners();
  }

  set areaofwork(String value) {
    _areaofwork = value;
    notifyListeners();
  }

  set repeat(String value) {
    _repeat = value;
    notifyListeners();
  }

  bool _isAccountUpdated = false;

  bool get isAccountUpdated => _isAccountUpdated;

  set isAccountUpdated(bool value) {
    _isAccountUpdated = value;
    notifyListeners();
  }
}

class AuthProvider extends ChangeNotifier {
  String? userToken;

  void setUserToken(String? token) {
    userToken = token;
    notifyListeners();
  }

}
