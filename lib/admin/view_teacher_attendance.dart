import 'package:flutter/material.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/model/teacher_attendance_model.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_attendance_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class ViewTeacherAttendance extends StatefulWidget {
  const ViewTeacherAttendance({Key? key}) : super(key: key);

  @override
  _ViewTeacherAttendanceState createState() => _ViewTeacherAttendanceState();
}

class _ViewTeacherAttendanceState extends State<ViewTeacherAttendance> {
  DateTime date = DateTime.now();

  bool isLoading = false;

  List<TeacherAttendanceModel> attendance = [];
  TeacherAttendanceModel? todayAttendance;
  bool isTaken = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<TeacherAttendanceProvider>(context, listen: false)
        .fetAndSetTeacherAttendance()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    var st = Provider.of<TeacherAttendanceProvider>(context, listen: false);
    attendance.addAll(st.teacherAttendance);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAttendance() {
      var st;
      attendance.forEach((element) {
        if (formatDateTime(element.dateTime) ==
            formatDateTime(date.toString())) {
          st = element;
        }
      });
      return st;
    }

    todayAttendance = getAttendance();
    return Scaffold(
      appBar: getAppBar('Add attendance', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getNormalText(
                            formatDateTime(date.toString()), 13, Colors.black),
                        IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            icon: Icon(Icons.calendar_today))
                      ],
                    ),
                    todayAttendance == null
                        ? getNormalTextCenter(
                            'No data available', 15, Colors.black)
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: getBoldCaptialText(
                                    'PRESENT TEACHERS', 15, MyColors.blueColor),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      todayAttendance!.presentTeachers.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        todayAttendance!.presentTeachers[index];
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              getBoldText(
                                                  (index + 1).toString(),
                                                  15,
                                                  Colors.black),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              getNormalText(data['name'], 14,
                                                  Colors.black),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: getBoldCaptialText(
                                    'ABSENT TEACHERS', 15, MyColors.blueColor),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      todayAttendance!.absentTeachers.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        todayAttendance!.absentTeachers[index];
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              getBoldText(
                                                  (index + 1).toString(),
                                                  15,
                                                  Colors.black),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              getNormalText(data['name'], 14,
                                                  Colors.black),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != date)
      setState(() {
        date = picked!;
      });
  }
}
