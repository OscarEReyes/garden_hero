import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/dashboard/utils/navbar_state.dart';
import 'package:garden_hero/dashboard/widgets/navbar.dart';
import 'package:garden_hero/garden/screens/garden_page.dart';


class DashboardPage extends StatefulWidget {
  final FirebaseUser firebaseUser;

  DashboardPage(this.firebaseUser);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  FirebaseUser firebaseUser;
  int _currentIndex;
  Widget _body;

  @override
  void initState() {
    super.initState();
    firebaseUser = widget.firebaseUser;
    _currentIndex = 0;
    _body = GardenPage();
  }

  @override
  Widget build(BuildContext context) {
    String name = firebaseUser.displayName;

    return Scaffold(
      appBar: AppBar(title: Text("Garden Hero"),),
      body: _body,
      bottomNavigationBar: NavBarState(
        onTapped: _onTabTapped,
        currentIndex: _currentIndex,
        child: NavBar(),
      ),
    );
  }

   void _onTabTapped(int index) async{
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _body = GardenPage();
      } else if(index == 1) {
        // body = Container();
      } else if(index == 2) {
        _body = Scaffold();
      }
    });
  }
}

