import 'package:flutter/material.dart';
import 'package:messenger_app/services/universe.dart';

class UniverseCreateView extends StatefulWidget {
  const UniverseCreateView({Key? key}) : super(key: key);

  @override
  _UniverseCreateViewState createState() => _UniverseCreateViewState();
}

class _UniverseCreateViewState extends State<UniverseCreateView> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  void _createUniverse(String name) async {
    final response = await UniverseService().createUniverse(name);

    if (response.success) {
      // Si la création est réussie, vous pouvez afficher un message de succès ou naviguer vers une autre vue si nécessaire
      print('Universe created successfully');
    } else {
      // Si la création a échoué, affichez le message d'erreur
      setState(() {
        _errorMessage = response.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Universe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter universe name',
              ),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                if (name.isNotEmpty) {
                  _createUniverse(name);
                } else {
                  setState(() {
                    _errorMessage = 'Please enter a name';
                  });
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
