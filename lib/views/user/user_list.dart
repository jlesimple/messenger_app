import 'package:flutter/material.dart';
import 'package:messenger_app/services/authentification.dart';
import 'package:messenger_app/models/user.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final AuthentificationService _authService = AuthentificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder(
        future: _authService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<User> users = snapshot.data as List<User>;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.username), // Optionnel: vous pouvez afficher d'autres informations ici
                );
              },
            );
          }
        },
      ),
    );
  }
}
