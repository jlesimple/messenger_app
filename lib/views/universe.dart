import 'package:flutter/material.dart';
import 'package:messenger_app/services/universe.dart';
import 'package:messenger_app/models/universe.dart';
import 'package:messenger_app/views/universe_detail.dart';
import 'package:messenger_app/views/universe_create.dart';

class UniverseView extends StatefulWidget {
  const UniverseView({Key? key}) : super(key: key);

  @override
  State<UniverseView> createState() => _UniverseViewState();
}

class _UniverseViewState extends State<UniverseView> {
  final UniverseService _universeService = UniverseService();
  List<Universe> _universes = [];

  @override
  void initState() {
    super.initState();
    _fetchUniverses();
  }

  Future<void> _fetchUniverses() async {
    final universeInfos = await _universeService.getAllUniverseInfo();
    final List<Universe> universes = [];

    for (final info in universeInfos) {
      print('Universe info: $info'); // Imprimer chaque info de l'univers
      final universe = Universe(
        id: info['id'].toString(),
        name: info['name'],
        description: info['description'] ?? '', // Assigner la description
        image: info['image'],
      );
      universes.add(universe);
    }

    setState(() {
      _universes = universes;
    });
  }

  void _navigateToDetail(Universe universe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniverseDetailView(universe: universe),
      ),
    );
  }

  void _createNewUniverse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniverseCreateView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universes'),
        actions: [
          IconButton(
            onPressed: _createNewUniverse,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _universes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _universes.length,
              itemBuilder: (context, index) {
                final universe = _universes[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(universe),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    height: 75, // Ajustez la hauteur au besoin
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                        left: BorderSide(color: Colors.grey),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Image.network(
                            'https://mds.sprw.dev/image_data/${universe.image}',
                            height: 60.0,
                            width: 60.0,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image_not_supported,
                              size: 60.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  universe.name,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
