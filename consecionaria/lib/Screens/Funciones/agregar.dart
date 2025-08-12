import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgregarAutoScreen extends StatefulWidget {
  @override
  State<AgregarAutoScreen> createState() => _AgregarAutoScreenState();
}

class _AgregarAutoScreenState extends State<AgregarAutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController anioController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();

  bool _loading = false;

  Future<void> _guardarAuto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance.collection('autos').add({
        'Marca': marcaController.text.trim(),
        'Modelo': modeloController.text.trim(),
        'Año': int.parse(anioController.text.trim()),
        'Color': colorController.text.trim(),
        'Precio': double.parse(precioController.text.trim()),
        'Estado': estadoController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el auto: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Auto')),
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
                  final n = int.tryParse(value);
                  if (n == null) return 'Año inválido';
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
                  final n = double.tryParse(value);
                  if (n == null) return 'Precio inválido';
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
                      onPressed: _guardarAuto,
                      child: const Text('Guardar Auto'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
