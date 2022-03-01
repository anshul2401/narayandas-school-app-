import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/student_calander.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';

class StudentAttendanceCalanderView extends StatefulWidget {
  String studentId;

  StudentAttendanceCalanderView({Key? key, required this.studentId})
      : super(key: key);

  @override
  State<StudentAttendanceCalanderView> createState() =>
      _StudentAttendanceCalanderViewState();
}

class _StudentAttendanceCalanderViewState
    extends State<StudentAttendanceCalanderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Attendance Record', context),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getBoldText('Present Days', 15, MyColors.blueColor),
              Container(
                height: 400,
                child: StudentCalanderView(
                  isForPresent: true,
                  studentId: widget.studentId,
                ),
              ),
              getBoldText('Absent Days', 15, MyColors.blueColor),
              Container(
                height: 400,
                child: StudentCalanderView(
                  isForPresent: false,
                  studentId: widget.studentId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
