/*import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Registro'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // tarjeta blanca con formulario
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'REGISTRO DE USUARIO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // campos del formulario
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // boton de registro
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('REGISTRARSE'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // enlace a login
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('¿Ya tienes cuenta? Inicia sesión aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import necesario

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Guardar datos adicionales en Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, stack) {
      print("🔥 Error Firebase Register: $e");
      print("📜 Stack trace: $stack");
      setState(() {
        _errorMessage = e.toString();
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error de Registro'),
          content: Text('$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Registro'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'REGISTRO DE USUARIO',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage != null)
                        Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                      _loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _register,
                              child: const Text('REGISTRARSE'),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    const Text('¿Ya tienes cuenta? Inicia sesión aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
