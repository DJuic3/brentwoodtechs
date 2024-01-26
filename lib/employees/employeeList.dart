
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';




class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }


}

class UserDetails extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Email: ${user['email']}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5,
          ),
        ),

        Text(
          'Name: ${user['name']}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ),
        Text(
          'Gender: ${user['gender']}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5,
          ),
        ),
        Text(
          'Department: ${user['department']}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Employment Status: ${user['status']}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5,
          ),
        ),
        Text(
          'Phone Number: ${user['phonenumber']}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5,
          ),
        ),


      ],
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  // final User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(user['name']),
      children: <Widget>[
        UserDetails(user: user),

      ],
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> userData = [];
  bool isGridView = false;



  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    try {
      final response = await http.get(
        Uri.parse('http://146.190.50.77:81/api/mobileusers'),
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = jsonDecode(response.body);

        // Ensure that data is a List<Map<String, dynamic>>
        if (data.isNotEmpty && data.first is Map<String, dynamic>) {
          setState(() {
            userData = data.cast<Map<String, dynamic>>();
          });
        } else {
          print('Invalid API response format');
        }
      } else {
        // Handle non-200 status code
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error fetching data: $e');
    }
  }
  Future<void> _refreshData() async {
    await fetchData();

  }
  Future<List<User>> searchUsers(String searchTerm) async {
    final url = Uri.parse('http://146.190.50.77:81/api/search-users');
    //?searchTerm=$searchTerm
    final response = await http.post(url, body: {'searchTerm': searchTerm});
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<User> users = jsonData.map((data) => User.fromJson(data)).toList();
      print(response.body);
      return users;
    } else {
      throw Exception('Failed to search users');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            const SizedBox(height: 10),
            AppBar(
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
                'Staff Members',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: [
                ToggleButtons(
                  isSelected: [!isGridView, isGridView],
                  onPressed: (int index) {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                  children: const [
                    Icon(Icons.view_list),
                    Icon(Icons.grid_on),
                  ],
                ),
              ],
            ),

            if (isGridView) // Display GridView
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final user = userData[index];
                    return UserCard(user: user);
                  },
                ),
              ),
            if (!isGridView) // Display ListView
              Expanded(
                child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final user = userData[index];
                    return Column(
                      children: [
                        UserCard(user: user),
                        if (index < userData.length - 1) const Divider(),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

}


