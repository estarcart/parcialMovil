import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'itemWidget.dart';

class WelcomeMenuPage extends StatefulWidget {
  @override
  _WelcomeMenuPageState createState() => _WelcomeMenuPageState();
}

class _WelcomeMenuPageState extends State<WelcomeMenuPage> {
  List<dynamic> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  Future<void> _getItems() async {
    setState(() {
      _isLoading = true;
    });

    const String apiUrl = 'http://10.0.2.2:3000/items';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': token!,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> items = responseData['items'];

        setState(() {
          _items = items;
        });
      } else {
        // Handle request errors
        print('Error fetching items');
      }
    } catch (e) {
      // Handle errors
      print('Connection error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retro Shop'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No hay items disponibles'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ItemWidget(item: item);
                  },
                ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Remove stored token
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Navigate back to login page
    Navigator.pushReplacementNamed(context, '/');
  }
}
