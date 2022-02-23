import 'package:flutter/material.dart';
import 'package:narayandas_app/chat/chat_home.dart';
import 'package:narayandas_app/chat2/page/chats_page.dart';
import 'package:narayandas_app/provider/notice_provider.dart';
import 'package:narayandas_app/provider/teacher_attendance_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/teacher/profile_page.dart';
import 'package:narayandas_app/teacher/t_home_page.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  bool isLoading = false;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    THomePage(),
    ChatsPage(),
    TeacherProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<TeacherProvider>(context, listen: false)
          .fetAndSetTeachers()
          .then((value) {});
    });
    Future.delayed(Duration.zero).then((value) {
      Provider.of<TeacherAttendanceProvider>(context, listen: false)
          .fetAndSetTeacherAttendance()
          .then((value) {});
    });

    Provider.of<NoticeProvider>(context, listen: false)
        .fetchAndSetNotice()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
      body: isLoading ? getLoading(context) : _widgetOptions[_selectedIndex],
    );
  }
}
