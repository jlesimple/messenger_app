import 'package:flutter/material.dart';
import 'package:messenger_app/services/authentification.dart';
import 'package:messenger_app/views/home.dart';

class UserUpdateScreen extends StatefulWidget {
  const UserUpdateScreen({Key? key}) : super(key: key);

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final AuthentificationService _authentificationservice =
      AuthentificationService();
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _authentificationservice.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _usernameController.text = userInfo['username'] ?? '';
        _emailController.text = userInfo['email'] ?? '';
        _firstnameController.text = userInfo['firstname'] ?? '';
        _lastnameController.text = userInfo['lastname'] ?? '';
      });
    }
  }

  void _updateUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;
    final String firstname = _firstnameController.text;
    final String lastname = _lastnameController.text;

    final response = await _authentificationservice.register(
      username,
      password,
      email,
      firstname,
      lastname,
    );

    if (response.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _message = response.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Update User')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white, // Couleur de fond de la page
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_message != null)
                Container(
                  alignment: Alignment.center,
                  child: Text(_message!),
                ),
              SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                  onPressed: _updateUser,
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF137C8B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
