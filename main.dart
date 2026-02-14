import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('notes');
  runApp(SmartToolsApp());
}

class SmartToolsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Tools Premium',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tools = [
    {'name': 'Calculator', 'icon': Icons.calculate, 'color': Colors.cyan, 'grad': [Colors.cyan, Colors.blue]},
    {'name': 'Converter', 'icon': Icons.swap_vert, 'color': Colors.indigo, 'grad': [Colors.indigo, Colors.purple]},
    {'name': 'Age Calc', 'icon': Icons.cake, 'color': Colors.orange, 'grad': [Colors.orange, Colors.redAccent]},
    {'name': 'Password', 'icon': Icons.security, 'color': Colors.emerald, 'grad': [Colors.emerald, Colors.teal]},
    {'name': 'QR Creator', 'icon': Icons.qr_code_2, 'color': Colors.violet, 'grad': [Colors.violet, Colors.deepPurple]},
    {'name': 'Quick Notes', 'icon': Icons.edit_note, 'color': Colors.amber, 'grad': [Colors.amber, Colors.orangeAccent]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: tools.length,
        itemBuilder: (context, i) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: tools[i]['grad']),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tools[i]['icon'], size: 45, color: Colors.white),
              Text(tools[i]['name'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}