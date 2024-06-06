import 'package:flutter/material.dart';
import 'package:messenger_app/services/authentification.dart';
import 'package:messenger_app/views/home.dart';
import 'package:messenger_app/views/authentification/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthentificationService _authentificationservice =
      AuthentificationService();
  String? _message;

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await _authentificationservice.login(username, password);

    if (response.success) {
      if (response.token != null) {
        await _authentificationservice.saveToken(response.token!);
      }
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
        title: const Center(child: Text('Connexion')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Color(0xFF137C8B).withOpacity(0.3)),
              foregroundColor: MaterialStateProperty.all(const Color(0xFF137C8B)),
            ),
            child: const Text('Inscription'),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Couleur de fond de la page
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Nom d\'utilisateur',
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  obscureText: true,
                ),
                if (_message != null) SizedBox(height: 16),
                if (_message != null)
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      _message!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Connexion', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF137C8B)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
