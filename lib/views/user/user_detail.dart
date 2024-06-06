import 'package:flutter/material.dart';
import 'package:messenger_app/models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${user.username}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('First Name: ${user.firstName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Last Name: ${user.lastName}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
