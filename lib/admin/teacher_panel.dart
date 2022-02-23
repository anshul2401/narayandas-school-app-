import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_parent_details.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/search_student.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/admin/view_teacher_attendance.dart';
import 'package:narayandas_app/utils/helper.dart';

class TeacherPanel extends StatefulWidget {
  const TeacherPanel({Key? key}) : super(key: key);

  @override
  _TeacherPanelState createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar('Teacher Activity', context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getActionCard('add_teacher_attendance_b.png', 'Add attendance',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTeacherAttendance()));
              }),
              getActionCard(
                'view.png',
                'View Attendance',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewTeacherAttendance()));
                },
              ),
              getActionCard(
                'add_teacher.png',
                'Add Teacher',
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddTeacher()));
                },
              ),
              getActionCard(
                'edit_teacher.png',
                'Edit Teacher',
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TeacherList()));
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
