import 'package:flutter/cupertino.dart';

class UserDataModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String _gender = '';
  String _phone = '';
  String _empstatus = '';
  String _areaofwork = '';
  String _repeat = '';


  DateTime get selectedDate => _selectedDate;
  String get gender => _gender;
  String get phone => _phone;
  String get empstatus => _empstatus;
  String get areaofwork => _areaofwork;
  String get repeat => _repeat;



  set selectedDate(DateTime value) {
    _selectedDate = value;
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
}
