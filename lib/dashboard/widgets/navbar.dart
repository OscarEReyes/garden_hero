import 'package:flutter/material.dart';
import 'package:garden_hero/dashboard/utils/navbar_state.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    return BottomNavigationBar(
      onTap: NavBarState.of(context).onTapped, // new
      currentIndex: NavBarState.of(context).currentIndex, // new
      items: [
        //0xe804 profile icon code.
        _buildNavigationBarItem(
         const IconData(0xe8b6, fontFamily: 'MaterialIcons'),
          "Search", 
          color
        ),
        _buildNavigationBarItem(
          const IconData(0xe0be, fontFamily: 'MaterialIcons'), 
          "Invites", 
          color
        ),
        _buildNavigationBarItem(
          const IconData(0xe7fd, fontFamily: 'MaterialIcons'), 
          "Profile", 
          color
        ),
      ],
    );

    
  }

  BottomNavigationBarItem _buildNavigationBarItem(
    IconData iconData,
    String text,
    Color color
  ) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Color.fromRGBO(102,102,102,1.0),
      ),
      activeIcon: Icon(
        iconData, 
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color
        )
      )
    );
  }
}

  BottomNavigationBarItem _buildNavigationBarItem(
    IconData iconData, 
    String text, 
    Color color
  ) 
  {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Color.fromRGBO(102,102,102,1.0),
      ),
      activeIcon: Icon(
        iconData, 
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color
        )
      )
    );
  }