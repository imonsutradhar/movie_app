import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_wrapper.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Box',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),

      home:  LoginScreen(),
    );
  }
}