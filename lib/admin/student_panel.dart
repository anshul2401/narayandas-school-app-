import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_parent_details.dart';
import 'package:narayandas_app/admin/search_student.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/utils/helper.dart';

class StudentPanel extends StatefulWidget {
  const StudentPanel({Key? key}) : super(key: key);

  @override
  _StudentPanelState createState() => _StudentPanelState();
}

class _StudentPanelState extends State<StudentPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar('Student Activity', context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getActionCard('add_student_attendance_b.png', 'Add attendance',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectClass(
                              isHomework: false,
                              isViewHomework: false,
                              isPromotion: false,
                              isViewAttendance: false,
                              isAddNotification: false,
                            )));
              }),
              getActionCard(
                'view.png',
                'View Attendance',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectClass(
                                isHomework: false,
                                isViewHomework: false,
                                isPromotion: false,
                                isViewAttendance: true,
                                isAddNotification: false,
                              )));
                },
              ),
              getActionCard('add_homework_b.png', 'Add Homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectClass(
                              isHomework: true,
                              isViewHomework: false,
                              isPromotion: false,
                              isViewAttendance: false,
                              isAddNotification: false,
                            )));
              }),
              getActionCard('view.png', 'View Homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SelectClass(
                              isHomework: false,
                              isViewHomework: true,
                              isPromotion: false,
                              isViewAttendance: false,
                              isAddNotification: false,
                            )));
              }),
              getActionCard(
                'add_notification.png',
                'Send Notification',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectClass(
                                isHomework: false,
                                isViewHomework: false,
                                isPromotion: false,
                                isViewAttendance: false,
                                isAddNotification: true,
                              )));
                },
              ),
              getActionCard(
                'new_admission.png',
                'Add Student',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddParentDetail()));
                },
              ),
              getActionCard(
                'search_student.png',
                'Search Student',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchStudent(isEdit: false)));
                },
              ),
              getActionCard(
                'promote_class_b.png',
                'Promote Class',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectClass(
                                isHomework: false,
                                isViewHomework: false,
                                isPromotion: true,
                                isViewAttendance: false,
                                isAddNotification: false,
                              )));
                },
              ),
            ],
          ),
        ));
  }

  getActionCard(String imgUrl, String title, VoidCallback callback) {
    return Card(
        child: ListTile(
      onTap: callback,
      leading: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
            width: 40, height: 40, child: Image.asset('assets/images/$imgUrl')),
      ),
      title: Center(child: getBoldText(title, 15, Colors.black)),
    ));
  }
}
