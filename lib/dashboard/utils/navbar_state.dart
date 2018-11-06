import 'package:flutter/material.dart';

class NavBarState extends InheritedWidget {
  const NavBarState({
    Key key,
    @required this.currentIndex,
    @required this.onTapped,
    @required Widget child,
  }) : assert(currentIndex != null),
       assert(child != null),
       super(key: key, child: child);

  final int currentIndex;
  final Function onTapped;

  static NavBarState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(NavBarState);
  }

  @override
  bool updateShouldNotify(NavBarState old) => currentIndex != old.currentIndex;
}