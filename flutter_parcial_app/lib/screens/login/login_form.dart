import 'package:flutter/material.dart';
import 'package:flutter_parcial_app/screens/menu/menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    const String apiUrl = 'http://192.168.128.5:3000/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];

        // Guardar el token en el almacenamiento local
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Navegar al menú de bienvenida
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeMenuPage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Credenciales inválidas';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Nombre de usuario',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: const Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 20.0),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Iniciar sesión'),
              ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
