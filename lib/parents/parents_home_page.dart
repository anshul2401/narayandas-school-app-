import 'package:flutter/material.dart';
import 'package:narayandas_app/chat/chat_home.dart';
import 'package:narayandas_app/parents/const.dart';
import 'package:narayandas_app/parents/p_home_page.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/teacher/t_home_page.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;
  bool isLoading = false;
  static List<Widget> _widgetOptions = <Widget>[
    PHomePage(),
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
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<ParentsProvider>(context, listen: false)
          .fetchAndSetParents()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
    // var parents = Provider.of<ParentsProvider>(context, listen: false).parents;
    // var p = parents.firstWhere((element) {
    //   return element.id == currentUser!.roleId;
    // });
    // currentParent = p;
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
      body: isLoading ? getLoading(context) : _widgetOptions[_selectedIndex],
    );
  }
}
