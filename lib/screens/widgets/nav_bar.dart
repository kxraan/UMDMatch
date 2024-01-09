import 'package:flutter/material.dart';

import '../home.dart';
import '../authentication/signOut.dart';
import '../chat.dart';
import 'header.dart';
import '../authentication/auth.dart';

import 'package:flutter/material.dart';
import '../profile.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}
class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  final tabs = [
    Home(),
    ProfilePage(),
    ChatPageList(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            body: tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                //Navigator.push(context, MaterialPageRoute(builder: (context) => _screens[index]));
                //_currentIndex = index;
                // switch(index) {
                //   case 0:
                //     Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                //     break;
                //   case 1:
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                //     break;
                //   case 2:
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => Prompts()));
                //     break;
                // }
              },
            ),
            ),
        );
    }
}