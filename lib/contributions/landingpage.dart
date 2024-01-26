import 'dart:convert';
import 'package:brentwoodtechs/contributions/view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddContribution extends StatefulWidget {
  @override
  _AddContributionState createState() => _AddContributionState();
}

class _AddContributionState extends State<AddContribution> {
  List<Map<String, dynamic>> employees = [];

  TextEditingController employeeIdController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    final response = await http.get(Uri.parse('http://146.190.50.77:81/api/mobileusers'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        employees = data.map((employee) {
          return {
            'id': employee['id'],
            'name': employee['name'],
          };
        }).toList();
      });
    } else {
      print('Failed to load employees. Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Finance Record',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: employeeIdController.text.isNotEmpty
                          ? int.parse(employeeIdController.text)
                          : null,
                      items: employees.map((employee) {
                        return DropdownMenuItem<int>(
                          value: employee['id'],
                          child: Text(employee['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          employeeIdController.text = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Member',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_validateForm()) {
                          _createFinanceRecord();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Submit Contribution',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    if (employeeIdController.text.isEmpty || amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _createFinanceRecord() async {
    final apiUrl = 'http://146.190.50.77:81/api/finance/store';

    Map<String, dynamic> data = {
      'employee_id': int.parse(employeeIdController.text),
      'amount': double.parse(amountController.text),
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {

      print('Finance Record added successfully.');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FinanceTableScreen()),
      );
    } else {
      print('Failed to add finance record. Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 40.0);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text('Add Contribution'),
      backgroundColor: Colors.red,
      actions: [

      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddContribution(),
  ));
}
