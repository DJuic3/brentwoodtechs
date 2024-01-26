import 'package:flutter/material.dart';




class SearchableDropdown extends StatefulWidget {
  final List<String> workList;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  const SearchableDropdown({super.key, 
    required this.workList,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  late String _selectedValue;
  late String _searchTerm;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
    _searchTerm = '';
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredList = widget.workList
        .where((option) =>
        option.toLowerCase().contains(_searchTerm.toLowerCase()))
        .toList();

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchTerm = value;
            });
          },
        ),
        DropdownButton(
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(9),
          items: filteredList.map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(),
              ),
            ),
          ).toList(),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          iconSize: 24,
          elevation: 16,
          underline: Container(height: 0),
          style: const TextStyle(color: Colors.black),
          value: _selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              _selectedValue = newValue!;
              widget.onChanged(newValue);
            });
          },
        ),
      ],
    );
  }
}
