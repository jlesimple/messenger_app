import 'package:flutter/material.dart';
import 'package:messenger_app/services/authentification.dart';
import 'package:messenger_app/views/home.dart';
import 'package:messenger_app/views/authentification/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final AuthentificationService _authentificationservice =
      AuthentificationService();
  String? _message;

  void _register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;
    final String firstname = _firstnameController.text;
    final String lastname = _lastnameController.text;

    final response = await _authentificationservice.register(
        username, password, email, firstname, lastname);

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
        title: const Center(child: Text('Inscription')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Color(0xFF137C8B).withOpacity(0.3)),
              foregroundColor: MaterialStateProperty.all(const Color(0xFF137C8B)),
            ),
            child: const Text('Connexion'),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Couleur de fond de la page
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Centrer les éléments horizontalement
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
                    fillColor: Colors.grey[200], // Fond gris pour le champ de texte
                    hintText: 'Nom d\'utilisateur',
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    border: OutlineInputBorder(borderSide: BorderSide.none), // Supprimer le trait noir
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajouter un padding
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200], // Fond gris pour le champ de texte
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    border: OutlineInputBorder(borderSide: BorderSide.none), // Supprimer le trait noir
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajouter un padding
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200], // Fond gris pour le champ de texte
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    border: OutlineInputBorder(borderSide: BorderSide.none), // Supprimer le trait noir
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajouter un padding
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200], // Fond gris pour le champ de texte
                    hintText: 'Prénom',
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    border: OutlineInputBorder(borderSide: BorderSide.none), // Supprimer le trait noir
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajouter un padding
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200], // Fond gris pour le champ de texte
                    hintText: 'Nom',
                    hintStyle: TextStyle(color: Colors.grey[400]), // Couleur de la police pour le placeholder
                    border: OutlineInputBorder(borderSide: BorderSide.none), // Supprimer le trait noir
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajouter un padding
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75, // 75% de la largeur de l'écran
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text('S\'inscrire', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color(0xFF137C8B)), // Couleur de fond du bouton
                    ),
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
