import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/account.dart';
import 'package:narayandas_app/admin/account_panel.dart';
import 'package:narayandas_app/admin/add_gallery_image.dart';
import 'package:narayandas_app/admin/add_meal.dart';
import 'package:narayandas_app/admin/add_notification.dart';
import 'package:narayandas_app/admin/add_parent_details.dart';
import 'package:narayandas_app/admin/add_story.dart';
import 'package:narayandas_app/admin/add_student.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/approve_fees.dart';
import 'package:narayandas_app/admin/menu/menu_item.dart';
import 'package:narayandas_app/admin/parent_panel.dart';
import 'package:narayandas_app/admin/parents_list.dart';
import 'package:narayandas_app/admin/search_parent.dart';
import 'package:narayandas_app/admin/search_student.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/student_panel.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/admin/teacher_panel.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/admin/view_teacher_attendance.dart';
import 'package:narayandas_app/chat/chat_home.dart';
import 'package:narayandas_app/chat/chatscreen.dart';
import 'package:narayandas_app/chat2/page/chats_page.dart';
import 'package:narayandas_app/login.dart';
import 'package:narayandas_app/provider/account_provider.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/provider/homework_provider.dart';
import 'package:narayandas_app/provider/meal_provider.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/shared_pref.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminHomePage> {
  bool isLoading = false;
  String hh = '';
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<ParentsProvider>(context, listen: false)
          .fetchAndSetParents()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<FeesProvider>(context, listen: false)
          .fetAndSetFees()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<StudentProvider>(context, listen: false)
          .fetchAndSetStudents()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<MealProvider>(context, listen: false)
          .fetAndSetMeal()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<HomeworkProvider>(context, listen: false)
          .fetAndSetHomework()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<AccountProvider>(context, listen: false)
          .fetchAndSetAccount()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<TeacherProvider>(context, listen: false)
          .fetAndSetTeachers()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
      // callApi();
    });

    super.initState();
  }

  callApi() async {
    hh = (await SharedPreferenceHelper().getUserId())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                    ),
                  ),
                  Spacer(),
                  getBoldTextCenter('Welcome Admin', 15, MyColors.blueColor),
                ],
              ),
            ),
            ListTile(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                final prefs = await SharedPreferences.getInstance();
                final success = await prefs.remove('USERKEY');
                final successs = await prefs.remove('USERROLEKEY');
                setState(() {
                  isLoading = false;
                });
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              leading: Icon(
                Icons.logout,
                color: MyColors.blueColor,
              ),
              title: getNormalText('Logout', 15, Colors.black),
            )
          ],
        ),
      ),
      appBar: getAppBar('Welcome Admin', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // getNormalText(hh, 15, Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getActionButtonTwo('student2.png', 'Student', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StudentPanel()));
                        }),
                        getActionButtonTwo(
                          'teacher2.png',
                          'Teacher',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeacherPanel()));
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getActionButtonTwo('parent2.png', 'Parent', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParentPanel()));
                        }),
                        getActionButtonTwo(
                          'account.png',
                          'Account',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountPanel()));
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getActionButtonTwo('edit_meal_b.png', 'Meal', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMeal()));
                        }),
                        getActionButtonTwo(
                          'chat.png',
                          'Chat',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatsPage()));
                          },
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getActionButtonTwo(
                          'gallery2.png',
                          'Gallery',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddGalleryImage()));
                          },
                        ),
                        getActionButtonTwo(
                            'add_notification.png', 'Add Notification', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddNotification()));
                        }),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getActionButtonTwo(
                          'edit_teacher.png',
                          'Menu',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuItem()));
                          },
                        ),
                        getActionButtonTwo(
                          'story.png',
                          'Add Story',
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddStory()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget getActionButton(
      String imgName, String text, VoidCallback onVoidCallback) {
    return GestureDetector(
      onTap: onVoidCallback,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.width / 5,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Image.asset(
                    'assets/images/$imgName',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 30,
                child: getBoldTextCenter(
                  text,
                  14,
                  Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getActionButtonTwo(
      String imgName, String text, VoidCallback onVoidCallback) {
    return GestureDetector(
      onTap: onVoidCallback,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.35,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Image.asset(
                    'assets/images/$imgName',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: MyColors.blueColor.withOpacity(0.9),
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.35,
                height: 30,
                child: getBoldTextCenter(
                  text,
                  14,
                  Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
