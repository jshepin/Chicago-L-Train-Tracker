import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:CTA_Tracker/exports.dart';

class BtmBar extends StatefulWidget {
  @override
  _BtmBarState createState() => _BtmBarState();
}

int _selectedIndex = 0;

class _BtmBarState extends State<BtmBar> {
  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex != 0) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              curve: Curves.fastLinearToSlowEaseIn,
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 50),
              child: Home()));
    } else if (index == 1 && _selectedIndex != 1) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              curve: Curves.fastLinearToSlowEaseIn,
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 50),
              child: Lines()));
    } else if (index == 2 && _selectedIndex != 2) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              curve: Curves.fastLinearToSlowEaseIn,
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 50),
              child: FullMap(getLines()[0], all: true)));
    } else if (index == 3 && _selectedIndex != 3) {
      Navigator.pushReplacement(
          context,
          PageTransition(
              curve: Curves.fastLinearToSlowEaseIn,
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 50),
              child: Settings()));
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 58,
      child: BottomNavigationBar(
        backgroundColor: getSecondary(context),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 27,
              ),
              label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_outline_rounded,
              size: 27,
            ),
            label: "Stations",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                size: 27,
              ),
              label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: 27,
              ),
              label: "Settings"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            isDark(context) ? Colors.blue[400] : Color(0xff0073BA),
        onTap: _onItemTapped,
      ),
    );
  }
}
