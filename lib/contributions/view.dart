import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Finance {
  final int id;
  final String name;
  final double amount;

  Finance({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory Finance.fromJson(Map<String, dynamic> json) {
    return Finance(
      id: json['id'],
      name: json['name'],
      amount: json['amount'] is String ? double.parse(json['amount']) : json['amount'].toDouble(),
    );
  }
}

class FinanceTableScreen extends StatefulWidget {
  @override
  _FinanceTableScreenState createState() => _FinanceTableScreenState();
}

class _FinanceTableScreenState extends State<FinanceTableScreen> {
  List<Finance> finances = [];

  @override
  void initState() {
    super.initState();
    _fetchFinances();
  }

  Future<void> _fetchFinances() async {
    final response = await http.get(Uri.parse('http://146.190.50.77:81/api/finance/index'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> financeData = responseData['finances'];

      List<Finance> financeList = financeData.map((finance) => Finance.fromJson(finance)).toList();

      setState(() {
        finances = financeList;
      });
    } else {
      // Handle the error
      print('Failed to load finances. Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(financeList: finances),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PaginatedDataTable(
            header: Text('Finance Records', style: TextStyle(fontWeight: FontWeight.bold)),
            rowsPerPage: 8,
            columns: [
              DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            source: _FinanceDataSource(financeList: finances),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Finance> financeList;

  CustomAppBar({required this.financeList});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 40.0);

  @override
  Widget build(BuildContext context) {
    double totalAmount = financeList.map((finance) => finance.amount).fold(0, (sum, amount) => sum + amount);

    return AppBar(
      title: Text('Captured Income'),
      backgroundColor: Colors.red,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Amount'),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinanceDataSource extends DataTableSource {
  final List<Finance> financeList;

  _FinanceDataSource({required this.financeList});

  @override
  DataRow? getRow(int index) {
    if (index >= financeList.length) {
      return null;
    }
    final finance = financeList[index];
    return DataRow(cells: [
      DataCell(Text('${finance.id}')),
      DataCell(Text('${finance.name}')),
      DataCell(Text('\$${finance.amount}')),

    ]);
  }

  @override
  int get rowCount => financeList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
