import 'package:flutter/material.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/model/teacher_attendance_model.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_attendance_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddTeacherAttendance extends StatefulWidget {
  const AddTeacherAttendance({Key? key}) : super(key: key);

  @override
  _AddTeacherAttendanceState createState() => _AddTeacherAttendanceState();
}

class _AddTeacherAttendanceState extends State<AddTeacherAttendance> {
  bool isLoading = false;
  List<TeacherModel> presentTeachers = [];
  List<TeacherModel> absentTeachers = [];
  List<TeacherAttendanceModel> teacherAttendance = [];

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTaken = false;
    var st = Provider.of<TeacherAttendanceProvider>(context, listen: false);
    teacherAttendance.addAll(st.teacherAttendance);
    teacherAttendance.forEach((element) {
      if (formatDateTime(element.dateTime) ==
          formatDateTime(DateTime.now().toString())) {
        setState(() {
          isTaken = true;
        });
      }
    });

    var teacherProvider = Provider.of<TeacherProvider>(context);
    List<TeacherModel> teachers = teacherProvider.teacher;

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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getNormalText(
                          formatDateTime(DateTime.now().toString()),
                          14,
                          MyColors.blueColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    isTaken
                        ? getNormalText(
                            'Attendance already taken', 16, Colors.grey)
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: teachers.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    presentTeachers.contains(teachers[index])
                                        ? presentTeachers
                                            .remove(teachers[index])
                                        : presentTeachers.add(teachers[index]);
                                  });
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getBoldText((index + 1).toString(), 15,
                                            Colors.black),
                                        getNormalText(teachers[index].name, 14,
                                            Colors.black),
                                        presentTeachers
                                                .contains(teachers[index])
                                            ? Icon(Icons.check_box)
                                            : Icon(
                                                Icons.check_box_outline_blank)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                        shape: StadiumBorder(),
                        color: MyColors.blueColor,
                        child: getNormalText('Submit', 14, Colors.white),
                        onPressed: () {
                          List<Map<String, dynamic>> presentTeacherMap = [];
                          List<Map<String, dynamic>> absentTeacherMap = [];
                          teachers.forEach((e) {
                            presentTeachers.contains(e)
                                ? presentTeacherMap.add({
                                    'name': e.name,
                                    'teacher_id': e.id,
                                    'one_signal_id': e.oneSignalId
                                  })
                                : absentTeacherMap.add({
                                    'name': e.name,
                                    'teacher_id': e.id,
                                    'one_signal_id': e.oneSignalId
                                  });
                          });

                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(builder: (context, s) {
                                  return AlertDialog(
                                    title: getBoldText('Submit the attendance?',
                                        16, Colors.green),
                                    content: getNormalText(
                                        'Once submitted the attendance, cannot be changed',
                                        13,
                                        Colors.black),
                                    actions: [
                                      RaisedButton(
                                          color: Colors.red,
                                          child: getNormalText(
                                              'Cancel', 14, Colors.white),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      RaisedButton(
                                          color: Colors.green,
                                          child: getNormalText(
                                              'Submit', 14, Colors.white),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              isLoading = true;
                                            });
                                            // s(() {
                                            //   isLoading = true;
                                            // });
                                            var attendanceProvider = Provider
                                                .of<TeacherAttendanceProvider>(
                                                    context,
                                                    listen: false);
                                            var newAttendance =
                                                TeacherAttendanceModel(
                                                    id: DateTime.now()
                                                        .toString(),
                                                    dateTime: DateTime.now()
                                                        .toString(),
                                                    presentTeachers:
                                                        presentTeacherMap,
                                                    absentTeachers:
                                                        absentTeacherMap);
                                            attendanceProvider
                                                .addTeacherAttendance(
                                                    newAttendance)
                                                .catchError((error) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              s(() {
                                                isLoading = false;
                                              });
                                              return ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Somethineg went wrong'),
                                              ));
                                            }).then((value) {
                                              // s(() {
                                              //   isLoading = false;
                                              // });
                                              setState(() {
                                                isLoading = false;
                                                // 2/Navigator.of(context).pop();
                                                // _showMyDialog();
                                              });

                                              // ScaffoldMessenger.of(context)
                                              //     .showSnackBar(const SnackBar(
                                              //   content:
                                              //       Text('Attedance added'),
                                              // ));
                                            });
                                          }),
                                    ],
                                  );
                                });
                              });
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
