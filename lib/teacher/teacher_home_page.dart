import 'package:flutter/material.dart';
import 'package:narayandas_app/chat/chat_home.dart';
import 'package:narayandas_app/teacher/t_home_page.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    THomePage(),
    Home(),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('Chat'),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            backgroundColor: Colors.white,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: MyColors.blueColor,
        iconSize: 25,
        onTap: _onItemTapped,
        elevation: 5,
      ),
      // appBar: getAppBar('Welcome teacher', context),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
