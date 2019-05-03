import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/blocs/garden_list_bloc.dart';
import 'package:garden_hero/dashboard/screens/dashboard_rename.dart';
import 'package:garden_hero/pages/garden_list_page.dart';
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
    FirebaseAuth.instance.currentUser().then(
            (FirebaseUser user) async {

        }
    );

    return Scaffold(

      body: Center(
        child: Container(
	        width: MediaQuery.of(context).size.width,
          decoration:  BoxDecoration(
            color: Colors.grey[100].withOpacity(0.2),

            image:  DecorationImage(
              image:  AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Login!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    bool b = await _loginUser();

                    b
                      ? await checkUser(context)
                        .then((user) => Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context)
                            => BlocProvider(
                              bloc: GardenListBloc(user),
                              child: GardenListPage(),
                            )
                          )
                        )
                      )
                      : Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Wrong Email.'),
                          ),
                        );
                  },
                  textColor: Colors.white,
                  child: Text('Sign In.'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> checkUser(BuildContext context) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
    
  }
}