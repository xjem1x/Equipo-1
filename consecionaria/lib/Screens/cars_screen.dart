import 'package:flutter/material.dart';

class AutosTableScreen extends StatelessWidget {
  const AutosTableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos
    final autos = [
      {
        'Marca': 'Toyota',
        'Modelo': 'Corolla',
        'Año': 2020,
        'Color': 'Blanco',
        'Precio': 250000,
        'Estado': 'Disponible',
      },
      {
        'Marca': 'Nissan',
        'Modelo': 'Versa',
        'Año': 2019,
        'Color': 'Gris',
        'Precio': 220000,
        'Estado': 'Vendido',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Para agregar
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: autos.length,
        itemBuilder: (context, index) {
          final auto = autos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.directions_car),
              title: Text('${auto['Marca']} ${auto['Modelo']}'),
              subtitle: Text(
                  'Año: ${auto['Año']} - Color: ${auto['Color']} - \$${auto['Precio']}'),
              trailing: Text(
                auto['Estado'].toString(),
                style: TextStyle(
                  color: auto['Estado'] == 'Disponible'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              onTap: () {
              },
            ),
          );
        },
      ),
    );
  }
}
