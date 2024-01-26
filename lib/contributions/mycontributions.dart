import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ContributionsTable extends StatefulWidget {
  @override
  _ContributionsTableState createState() => _ContributionsTableState();
}

class _ContributionsTableState extends State<ContributionsTable> {
  List<dynamic> finances = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchContributions();
  }

  Future<void> fetchContributions() async {
    try {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      final userToken = sharedPreferences.getString('userToken');

      if (userToken == null) {
        print("User is not logged in.");
        return;
      }

      final response = await http.get(
        Uri.parse("http://146.190.50.77:81/api/personalitems"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          finances = jsonDecode(response.body)['finances'];

          totalAmount = finances.fold(
              0.0,
                  (previous, finance) =>
              previous + double.parse(finance['amount'].toString()));
        });
      } else {
        print("Error fetching contributions: ${response.statusCode}");
      }
    } catch (e) {print("Error fetching contributions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Contributions"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            DataTable(
              dividerThickness: 1.5,
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              columns: [
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("Amount"),
                ),
              ],
              rows: finances
                  .map<DataRow>((finance) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      finance['created_at'],
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      finance['amount'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return finances.indexOf(finance) % 2 == 0
                        ? Colors.grey.withOpacity(0.3)
                        : null;
                  },
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContributionsTable(),
  ));
}
