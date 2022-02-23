// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_gallery_image.dart';
import 'package:narayandas_app/admin/add_meal.dart';
import 'package:narayandas_app/admin/add_parent_details.dart';
import 'package:narayandas_app/admin/add_student.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/search_parent.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/login.dart';
import 'package:narayandas_app/model/notice_model.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/parents/pages/gallery.dart';
import 'package:narayandas_app/parents/story_view.dart';
import 'package:narayandas_app/provider/notice_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_attendance_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/carousel.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class THomePage extends StatefulWidget {
  const THomePage({Key? key}) : super(key: key);

  @override
  _THomePageState createState() => _THomePageState();
}

class _THomePageState extends State<THomePage> {
  bool isLoading = false;
  List<NoticeModel> notice = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<StudentProvider>(context, listen: false)
          .fetchAndSetStudents()
          .then((value) {});
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<TeacherProvider>(context, listen: false)
          .fetAndSetTeachers()
          .then((value) {});
    });
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<TeacherAttendanceProvider>(context, listen: false)
    //       .fetAndSetTeacherAttendance()
    //       .then((value) {});
    // });

    Provider.of<NoticeProvider>(context, listen: false)
        .fetchAndSetNotice()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    var noticeProvider = Provider.of<NoticeProvider>(context, listen: false);
    notice = List.from(noticeProvider.notice.reversed);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late TeacherModel teacherModel;
    var teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    teacherModel =
        teacherProvider.teacher.firstWhere((e) => e.id == currentUser!.roleId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: getBoldText(
          ' Welcome ${teacherModel.name}',
          16,
          Colors.white,
        ),
        backgroundColor: MyColors.blueColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoreStoriesTeacher()));
              },
              icon: Icon(Icons.camera_alt))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: MyColors.blueColor,
              ),
              trailing: teacherModel.canEditMeal
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Icon(Icons.lock),
              title: const Text('Edit meal'),
              onTap: teacherModel.canEditMeal
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddMeal()));
                    }
                  : () {},
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: MyColors.blueColor,
              ),
              trailing: teacherModel.canAddFees
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Icon(Icons.lock),
              title: const Text('Add Fees'),
              onTap: teacherModel.canAddFees
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchParent(
                                    isEdit: false,
                                  )));
                    }
                  : () {},
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: MyColors.blueColor,
              ),
              trailing: teacherModel.canAddGallery
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Icon(Icons.lock),
              title: const Text('Add Gallery'),
              onTap: teacherModel.canAddGallery
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGalleryImage()));
                    }
                  : () {},
            ),
            ListTile(
              leading: Icon(
                Icons.upgrade,
                color: MyColors.blueColor,
              ),
              trailing: teacherModel.canPromoteClass
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Icon(Icons.lock),
              title: const Text('Promote Class'),
              onTap: teacherModel.canPromoteClass
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectClass(
                                    isHomework: false,
                                    isViewHomework: false,
                                    isPromotion: true,
                                    isViewAttendance: false,
                                    isAddNotification: false,
                                  )));
                    }
                  : () {},
            ),
            ListTile(
              leading: Icon(
                Icons.add,
                color: MyColors.blueColor,
              ),
              trailing: teacherModel.canAddStudent
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Icon(Icons.lock),
              title: const Text('New Admission'),
              onTap: teacherModel.canAddStudent
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddParentDetail()));
                    }
                  : () {},
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.book,
            //     color: MyColors.blueColor,
            //   ),
            //   title: const Text('About Us'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => AboutUs()));
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.image,
                color: MyColors.blueColor,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Gallery()));
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.phone,
            //     color: MyColors.blueColor,
            //   ),
            //   title: const Text('Contact Us'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => ContactUs()));
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: MyColors.blueColor,
              ),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CarouselWithIndicatorDemo(
              notice: notice,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getActionButton('add_student_attendance_b.png', 'Attendance',
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectClass(
                                isHomework: false,
                                isViewHomework: false,
                                isPromotion: false,
                                isViewAttendance: false,
                                isAddNotification: false,
                              )));
                }, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectClass(
                                isHomework: false,
                                isViewHomework: false,
                                isPromotion: false,
                                isViewAttendance: true,
                                isAddNotification: false,
                              )));
                }),
                getActionButton(
                  'add_homework_b.png',
                  'Homework',
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectClass(
                                  isHomework: true,
                                  isViewHomework: false,
                                  isPromotion: false,
                                  isViewAttendance: false,
                                  isAddNotification: false,
                                )));
                  },
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectClass(
                                  isHomework: false,
                                  isViewHomework: true,
                                  isPromotion: false,
                                  isViewAttendance: false,
                                  isAddNotification: false,
                                )));
                  },
                ),
                // getActionButton('view_homework_b.png', ' View Homework', () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => SelectClass(
                //                 isHomework: false,
                //                 isViewHomework: true,
                //                 isPromotion: false,
                //                 isViewAttendance: false,
                //               )));
                // }),
              ],
            ),
            // Row(
            //   children: [
            //     getActionButton('view_meal_b.png', 'Meal', () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => ViewMeal()));
            //     }),
            //     getActionButton('add_fees_b.png', 'Add Fees', () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => SearchParent(
            //                     isEdit: false,
            //                   )));
            //     }),
            //   ],
            // ),
            // Row(
            //   children: [
            //     getActionButton(
            //       'new_admission.png',
            //       ' New Admission',
            //       () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => AddParentDetail()));
            //       },
            //     ),
            //     getActionButton(
            //       'add_teacher.png',
            //       'Add Teacher',
            //       () {
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) => AddTeacher()));
            //       },
            //     ),
            //     getActionButton(
            //       'add_fees_b.png',
            //       'Attendance',
            //       () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => SelectClass(
            //                       isHomework: false,
            //                       isViewHomework: false,
            //                       isPromotion: false,
            //                       isViewAttendance: true,
            //                     )));
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget getActionButton(String imgName, String text,
      VoidCallback onVoidCallback1, VoidCallback onVoidCallback2) {
    return Card(
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
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getButton(onVoidCallback1, 'Add', Colors.green),
                  getButton(onVoidCallback2, 'View', Colors.deepOrangeAccent),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
