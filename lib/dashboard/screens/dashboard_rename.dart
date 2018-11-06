import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_hero/dashboard/utils/navbar_state.dart';
import 'package:garden_hero/dashboard/widgets/navbar.dart';


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
    _body = Container();
  }

  @override
  Widget build(BuildContext context) {
    String name = firebaseUser.displayName;
    return Scaffold(
      appBar: AppBar(title: Text("HelpTX"),),
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
      // _currentIndex = index;
      if (index == 0) {
        // body = Container();
      } else if(index == 1) {
        // body = Container();
      } else if(index == 2) {
        _body = Scaffold();
      }
    });
  }
}


// Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
//             constraints: BoxConstraints(minWidth: 200.0, minHeight: 200.0),
//             child: WelcomeCard(name)
//           ),
//         ]
//       ),