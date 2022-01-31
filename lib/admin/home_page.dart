import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/account.dart';
import 'package:narayandas_app/admin/add_gallery_image.dart';
import 'package:narayandas_app/admin/add_meal.dart';
import 'package:narayandas_app/admin/add_student.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/approve_fees.dart';
import 'package:narayandas_app/admin/parents_list.dart';
import 'package:narayandas_app/admin/search_parent.dart';
import 'package:narayandas_app/admin/search_student.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/chat/chat_home.dart';
import 'package:narayandas_app/chat/chatscreen.dart';
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
      callApi();
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
              onTap: () {
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
              child: Column(
                children: [
                  // getNormalText(hh, 15, Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getActionButton('add_student_attendance_b.png',
                          'Add Student attendance', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectClass(
                                      isHomework: false,
                                      isViewHomework: false,
                                      isPromotion: false,
                                      isViewAttendance: false,
                                    )));
                      }),
                      getActionButton('add_teacher_attendance_b.png',
                          'Add Teacher attendance', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddTeacherAttendance()));
                      }),
                      getActionButton(
                        'edit_teacher.png',
                        'View Attendance',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectClass(
                                        isHomework: false,
                                        isViewHomework: false,
                                        isPromotion: false,
                                        isViewAttendance: true,
                                      )));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getActionButton('view_homework_b.png', ' Homework', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectClass(
                                      isHomework: false,
                                      isViewHomework: true,
                                      isPromotion: false,
                                      isViewAttendance: false,
                                    )));
                      }),
                      getActionButton('add_homework_b.png', 'Add Homework', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectClass(
                                      isHomework: true,
                                      isViewHomework: false,
                                      isPromotion: false,
                                      isViewAttendance: false,
                                    )));
                      }),
                      getActionButton('edit_meal_b.png', 'Add/Edit Meal', () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddMeal()));
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getActionButton(
                        'new_admission.png',
                        ' New Admission',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddStudent()));
                        },
                      ),
                      getActionButton(
                        'add_teacher.png',
                        'Add Teacher',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTeacher()));
                        },
                      ),
                      getActionButton(
                        'add_fees_b.png',
                        'Add Fees',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchParent(
                                        isEdit: false,
                                      )));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getActionButton(
                        'gallery.png',
                        'Add Gallery',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddGalleryImage()));
                        },
                      ),
                      getActionButton(
                        'promote_class_b.png',
                        'Promote Class',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectClass(
                                        isHomework: false,
                                        isViewHomework: false,
                                        isPromotion: true,
                                        isViewAttendance: false,
                                      )));
                        },
                      ),
                      getActionButton(
                        'approve_fees.png',
                        'Approve Fees',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApproveFees()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getActionButton(
                        'edit_teacher.png',
                        'Edit Teacher',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherList()));
                        },
                      ),
                      getActionButton(
                        'edit_teacher.png',
                        'Edit Parent',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchParent(isEdit: true)));
                        },
                      ),
                      getActionButton(
                        'approve_fees.png',
                        'Manage Account',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Account()));
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getActionButton('view_meal_b.png', 'Meal', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewMeal()));
                      }),
                      getActionButton(
                        'search_student.png',
                        'Search Student',
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchStudent(isEdit: false)));
                        },
                      ),
                      // getActionButton(
                      //   'approve_fees.png',
                      //   'Manage Account',
                      //   () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => ApproveFees()));
                      //   },
                      // ),
                    ],
                  ),
                  // RaisedButton(
                  //     child: const Text('Add Student'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => AddStudent()));
                  //     }),
                  // RaisedButton(
                  //     child: const Text('Chat Screen'),
                  //     onPressed: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Home()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('All Parents'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ParentsList()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Add Fees'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => AddStudent()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Add teacher'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => AddTeacher()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Add meal and meal list '),
                  //     onPressed: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => AddMeal()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Fees List and approve'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ApproveFees()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Add attendace'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => SelectClass(
                  //                     isHomework: false,
                  //                     isViewHomework: false,
                  //                     isPromotion: false,
                  //                   )));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Teacher List'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => TeacherList()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Add teacher attendance'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => AddTeacherAttendance()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Add homework'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => SelectClass(
                  //                     isHomework: true,
                  //                     isViewHomework: false,
                  //                     isPromotion: false,
                  //                   )));
                  //     }),
                  // RaisedButton(
                  //     child: Text('View homework'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => SelectClass(
                  //                     isHomework: false,
                  //                     isViewHomework: true,
                  //                     isPromotion: false,
                  //                   )));
                  //     }),
                  // RaisedButton(
                  //     child: Text('View meal'),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ViewMeal()));
                  //     }),
                  // RaisedButton(
                  //     child: Text('Login Page'),
                  //     onPressed: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => Login()));
                  //     }),
                ],
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
}
