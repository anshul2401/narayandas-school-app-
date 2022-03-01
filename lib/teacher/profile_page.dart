import 'package:flutter/material.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/teacher_attendance_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/teacher/calander.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({Key? key}) : super(key: key);

  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((value) {
      Provider.of<TeacherAttendanceProvider>(context, listen: false)
          .fetAndSetTeacherAttendance()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<TeacherProvider>(context, listen: false)
          .fetAndSetTeachers()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late TeacherModel teacherModel;
    var teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    teacherModel =
        teacherProvider.teacher.firstWhere((e) => e.id == currentUser!.roleId);

    return Scaffold(
      appBar: getAppBar('Profile', context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getBoldCaptialText('Attendance Record', 15, MyColors.blueColor),
              ExpansionTile(
                title: getNormalText('Present days', 14, Colors.black),
                children: [
                  Container(
                      height: 400,
                      child: CalanderView(
                        isForPresent: true,
                      )),
                ],
              ),
              Divider(),
              ExpansionTile(
                title: getNormalText('Absent days', 14, Colors.black),
                children: [
                  Container(
                      height: 400,
                      child: CalanderView(
                        isForPresent: false,
                      )),
                ],
              ),
              Divider(),
              getDetailContainer('Name', teacherModel.name),
              getDetailContainer('Address', teacherModel.address),
              getDetailContainer('phone no.', teacherModel.phone),
              getDetailContainer('Email', teacherModel.email),
            ],
          ),
        ),
      ),
    );
  }

  getDetailContainer(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getBoldCaptialText(title, 15, MyColors.blueColor),
          SizedBox(
            height: 2,
          ),
          getNormalText(content, 15, Colors.black),
        ],
      ),
    );
  }
}
