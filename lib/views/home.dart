import 'package:flutter/material.dart';
import 'package:messenger_app/services/authentification.dart';
import 'package:messenger_app/views/user/user_list.dart';
import 'package:messenger_app/views/authentification/login.dart';
import 'package:messenger_app/views/universe/universe.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthentificationService _apiService = AuthentificationService();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _apiService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _userName = userInfo['username'];
      });
    }
  }

  void _logout(BuildContext context) async {
    await _apiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _viewAllUsers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllUsersScreen()),
    );
  }

  void _viewAllUniverses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UniverseView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Hello ${_userName ?? ''}!'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
                height: MediaQuery.of(context).size.width * 0.4, // Same height as width
                child: GestureDetector(
                  onTap: () => _viewAllUsers(context),
                  child: Card(
                    color: Color(0xFF137c8b),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(Icons.person, size: 40, color: Colors.white), // Icon for users
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
                height: MediaQuery.of(context).size.width * 0.4, // Same height as width
                child: GestureDetector(
                  onTap: () => _viewAllUniverses(context),
                  child: Card(
                    color: Color(0xFF137c8b),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(Icons.account_balance, size: 40, color: Colors.white), // Icon for universes
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0), // Add space between bottom of screen and bottom app bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
              IconButton(
                icon: const Icon(Icons.account_balance), // Use a relevant icon for universes
                onPressed: () => _viewAllUniverses(context),
              ),
              IconButton( // Add IconButton for user update
                icon: const Icon(Icons.person_outline), // Use a relevant icon for user update
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserUpdateScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
