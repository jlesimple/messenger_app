import 'package:flutter/material.dart';
import 'package:messenger_app/services/user.dart';
import 'package:messenger_app/models/user.dart';
import 'package:messenger_app/views/user/user_detail.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder(
        future: _userService.getAllUsers(),
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
                  subtitle: Text(user.username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(user: user),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
