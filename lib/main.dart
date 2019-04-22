import 'package:flutter/material.dart';
import './pages/login.dart';


void main() => runApp(MyApp());

ThemeData theme = ThemeData(
	fontFamily: "Source_Sans_Pro",
	primaryColor: Color.fromRGBO(61, 223, 127, 1),
	buttonColor: Color.fromRGBO(61, 223, 127, 1),
	accentColor: Color.fromRGBO(239, 66, 136,1),
	textTheme: TextTheme(
		title: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
		subtitle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
		subhead: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
		body1: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
		button: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)
	)
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
	    theme: theme,
      debugShowCheckedModeBanner: false,
      title: 'Garden Hero',
      routes: {
        "login-page": (context) => LoginPage(),
      },
      home: LoginPage(),
    );
  }
}


