import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/dashboard/screens/dashboard_rename.dart';
import '../api.dart';

import 'dart:async';

import 'dart:ui' show ImageFilter;

class LoginPage extends StatelessWidget {
  Future<bool> _loginUser() async {
    final api = await FBApi.signInWithGoogle();
    if (api != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign In'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(
                  width: 250.0,
                  height: 250.0,
                ),
                child: Container(
                  color: Colors.cyan[100].withOpacity(0.7),
                ),
              ),
            ),
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  width: 250.0,
                  height: 250.0,
                  color: Colors.grey[100].withOpacity(0.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Login to the App!",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FlatButton(
                        color: Colors.black54,
                        onPressed: () async {
                          bool b = await _loginUser();

                          b
                            ? await checkUser(context)
                              .then((value) => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => DashboardPage(value))
                              )
                            )
                            : Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Wrong Email.'),
                                ),
                              );
                        },
                        textColor: Colors.white.withOpacity(0.5),
                        child: Text('Sign In.'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> checkUser(BuildContext context) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    final QuerySnapshot results = await Firestore.instance.collection("users")
      .where("email", isEqualTo: currentUser.email)
      .limit(1)
      .getDocuments();
    print("query done");

    print(results.documents.length);

    if (results.documents.length == 0 || 
      results.documents[0].data["zipcode"] == null || 
      results.documents[0].data["radius"] == null) {
      await _askForUserData(context, currentUser);
    }

    return currentUser;
    
  }

  Future<Null> _askForUserData(BuildContext context, FirebaseUser user) async {
    TextEditingController zipCodeController = TextEditingController();
    TextEditingController ageController = TextEditingController();


    return showDialog<Null>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return  AlertDialog(
          title:  Text('Please input the following data:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Zip Code"
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  maxLengthEnforced: true,
                  controller: zipCodeController,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Age"
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  maxLengthEnforced: true,
                  controller: ageController,
                )
              ],
            ),
          ),
          actions: <Widget>[
          FlatButton(
              child: Text('Accept'),
              onPressed: () {
                if (zipCodeController.text.length == 5 && ageController.text.length == 2) {
                  DocumentReference document = Firestore.instance.collection("users").document(user.email.hashCode.toString());
                  document.setData(
                    { 
                      "name" : user.displayName,
                      "email" : user.email,
                      "zipcode" : zipCodeController.text,
                      "age" : ageController.text,
                    }
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}