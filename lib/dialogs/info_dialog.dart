import 'package:flutter/material.dart';

class InfoDialog{
  information(BuildContext context, String title, String description,Card plant) {
    return showDialog(context: context,
      barrierDismissible: true,
      builder:(BuildContext context){
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[

              Text(description),
              Text(description),
              Text(description),
              Text(description),
              Text(description),
              Text(description),
              Text(description),
              Text(description),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=>Navigator.pop(context),
            child: Text("ok"),
          )
        ],
      );
      });
  }
}
