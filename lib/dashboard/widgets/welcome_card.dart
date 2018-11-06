import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  final String name;

  WelcomeCard(this.name);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        contentPadding: EdgeInsets.all(25.0),
        title: Text("Hi, $name",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w400
          ),
        )
      )
    );
  }
}