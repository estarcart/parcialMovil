import 'package:flutter/material.dart';
import 'package:flutter_parcial_app/screens/login/login.dart';
import 'package:flutter_parcial_app/screens/menu/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => LoginPage(), // Página de inicio
        '/welcome': (context) => WelcomeMenuPage(), // Página de menú de bienvenida
      },
    );
  }
}
