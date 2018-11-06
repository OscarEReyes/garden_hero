import 'package:flutter/material.dart';
import './pages/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garden Hero',
      routes: {
        "login-page": (context) => LoginPage(),
      },
      home: LoginPage(),
    );
  }
}


