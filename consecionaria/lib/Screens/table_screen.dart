import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Funciones/agregar.dart';
import 'Funciones/modificar.dart';
import 'Funciones/buscar.dart';

class AutosTableScreen extends StatelessWidget {
  AutosTableScreen({Key? key}) : super(key: key);

  final CollectionReference autosCollection =
      FirebaseFirestore.instance.collection('autos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuscarAutosScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarAutoScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: autosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final autos = snapshot.data!.docs;

          if (autos.isEmpty) {
            return const Center(child: Text('No hay autos registrados.'));
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
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Eliminar auto'),
                        content: const Text('¿Quieres eliminar este auto?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                    if (confirm ?? false) {
                      await autosCollection.doc(docId).delete();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
