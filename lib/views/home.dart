import 'package:flutter/material.dart';
import 'package:messenger_app/services/authentification.dart';
import 'package:messenger_app/views/authentification/login.dart';
import 'package:messenger_app/views/conversation/conversation.dart'; // Importez la vue ConversationsListView
import 'package:messenger_app/views/universe/universe.dart';
import 'package:messenger_app/views/user/user.dart';

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

  // Remplacez _selectConversation pour naviguer vers ConversationListView
  void _viewAllConversations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConversationListView()),
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
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                child: GestureDetector(
                  onTap: () => _viewAllUsers(context),
                  child: Card(
                    color: const Color(0xFF137c8b),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                child: GestureDetector(
                  onTap: () => _viewAllUniverses(context),
                  child: Card(
                    color: const Color(0xFF137c8b),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: const Icon(Icons.public, size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.4,
            child: GestureDetector(
              onTap: () => _viewAllConversations(context), // Utilisez la méthode pour afficher toutes les conversations
              child: Card(
                color: const Color(0xFF137c8b),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Icon(Icons.chat, size: 40, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
              IconButton(
                icon: const Icon(Icons.public),
                onPressed: () => _viewAllUniverses(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
