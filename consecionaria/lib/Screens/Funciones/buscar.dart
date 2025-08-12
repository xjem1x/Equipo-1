import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'modificar.dart';

class BuscarAutosScreen extends StatefulWidget {
  const BuscarAutosScreen({Key? key}) : super(key: key);

  @override
  State<BuscarAutosScreen> createState() => _BuscarAutosScreenState();
}

class _BuscarAutosScreenState extends State<BuscarAutosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  final CollectionReference autosCollection =
      FirebaseFirestore.instance.collection('autos');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getAutosStream() {
    if (_searchTerm.isEmpty) {
      // Si no hay término, devuelve todos los autos
      return autosCollection.snapshots();
    } else {
      // Buscar autos donde 'Marca' o 'Modelo' contenga _searchTerm (insensible a mayúsculas)
      // Nota: Firestore no tiene búsqueda LIKE, pero se pueden usar queries con 'where' exactas o usar plugins de búsqueda externa para búsquedas avanzadas.
      // Aquí hacemos una búsqueda simple que sólo funciona para coincidencias exactas o usando índices. 
      // Por eso, para búsqueda básica se recomienda traer todo y filtrar en cliente o usar plugins como Algolia.

      return autosCollection
          .where('Marca', isGreaterThanOrEqualTo: _searchTerm)
          .where('Marca', isLessThanOrEqualTo: '$_searchTerm\uf8ff')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Autos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar por Marca',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getAutosStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final autos = snapshot.data!.docs;

                if (autos.isEmpty) {
                  return const Center(child: Text('No se encontraron autos.'));
                }

                return ListView.builder(
                  itemCount: autos.length,
                  itemBuilder: (context, index) {
                    final autoData = autos[index].data()! as Map<String, dynamic>;
                    final docId = autos[index].id;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.directions_car),
                        title: Text('${autoData['Marca']} ${autoData['Modelo']}'),
                        subtitle: Text(
                            'Año: ${autoData['Año']} - Color: ${autoData['Color']} - \$${autoData['Precio']}'),
                        trailing: Text(
                          autoData['Estado'] ?? '',
                          style: TextStyle(
                            color: autoData['Estado'] == 'Disponible'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarAutoScreen(
                                docId: docId,
                                autoData: autoData,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
