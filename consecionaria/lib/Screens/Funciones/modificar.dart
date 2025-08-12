import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarAutoScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> autoData;

  const EditarAutoScreen({required this.docId, required this.autoData, Key? key}) : super(key: key);

  @override
  State<EditarAutoScreen> createState() => _EditarAutoScreenState();
}

class _EditarAutoScreenState extends State<EditarAutoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController marcaController;
  late TextEditingController modeloController;
  late TextEditingController anioController;
  late TextEditingController colorController;
  late TextEditingController precioController;
  late TextEditingController estadoController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    marcaController = TextEditingController(text: widget.autoData['Marca']);
    modeloController = TextEditingController(text: widget.autoData['Modelo']);
    anioController = TextEditingController(text: widget.autoData['Año'].toString());
    colorController = TextEditingController(text: widget.autoData['Color']);
    precioController = TextEditingController(text: widget.autoData['Precio'].toString());
    estadoController = TextEditingController(text: widget.autoData['Estado']);
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    anioController.dispose();
    colorController.dispose();
    precioController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  Future<void> _actualizarAuto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('autos').doc(widget.docId).update({
        'Marca': marcaController.text.trim(),
        'Modelo': modeloController.text.trim(),
        'Año': int.parse(anioController.text.trim()),
        'Color': colorController.text.trim(),
        'Precio': double.parse(precioController.text.trim()),
        'Estado': estadoController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el auto: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modificar Auto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa la marca' : null,
              ),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa el modelo' : null,
              ),
              TextFormField(
                controller: anioController,
                decoration: const InputDecoration(labelText: 'Año'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el año';
                  if (int.tryParse(value) == null) return 'Año inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa el color' : null,
              ),
              TextFormField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el precio';
                  if (double.tryParse(value) == null) return 'Precio inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingresa el estado' : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _actualizarAuto,
                      child: const Text('Guardar Cambios'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
