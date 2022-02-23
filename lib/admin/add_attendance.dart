import 'package:flutter/material.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class AddAttendance extends StatefulWidget {
  final String standard;
  const AddAttendance({Key? key, required this.standard}) : super(key: key);

  @override
  _AddAttendanceState createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  bool isLoading = false;
  List<StudentModel> presentStudents = [];
  List<StudentModel> absentStudents = [];
  List<StudentAttendanceModel> attendance = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<StudentProvider>(context, listen: false)
          .fetchAndSetStudents()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<StudentAttendanceProvider>(context, listen: false)
          .fetAndSetStudentAttendance()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
    });
    Future.delayed(Duration.zero).then((value) {
      Provider.of<AuthProvider>(context, listen: false)
          .fetchAndSetAuth()
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
    var st = Provider.of<StudentAttendanceProvider>(context, listen: false);
    attendance.addAll(st.studentAttendance);
    attendance.forEach((element) {
      if (formatDateTime(element.dateTime) ==
              formatDateTime(DateTime.now().toString()) &&
          element.standard == widget.standard) {
        setState(() {
          isTaken = true;
        });
      }
    });
    var studentProvider = Provider.of<StudentProvider>(context);
    List<StudentModel> students = studentProvider.students;
    List<StudentModel> filterStudent = students.where((e) {
      return e.standard == widget.standard;
    }).toList();
    return Scaffold(
      appBar: getAppBar('Add attendance', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getBoldText(widget.standard, 15, Colors.black),
                      ],
                    ),
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
                        ? getNormalTextCenter(
                            'Attendance For today is taken', 15, Colors.black)
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filterStudent.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    presentStudents
                                            .contains(filterStudent[index])
                                        ? presentStudents
                                            .remove(filterStudent[index])
                                        : presentStudents
                                            .add(filterStudent[index]);
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
                                        getNormalText(filterStudent[index].name,
                                            14, Colors.black),
                                        presentStudents
                                                .contains(filterStudent[index])
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
                          List<Map<String, dynamic>> presentStudentMap = [];
                          List<Map<String, dynamic>> absentStudentMap = [];
                          filterStudent.forEach((e) {
                            presentStudents.contains(e)
                                ? presentStudentMap.add({
                                    'name': e.name,
                                    'student_id': e.id,
                                    'parent_id': e.parentId
                                  })
                                : absentStudentMap.add({
                                    'name': e.name,
                                    'student_id': e.id,
                                    'parent_id': e.parentId
                                  });
                          });
                          var authProvider =
                              Provider.of<AuthProvider>(context, listen: false);

                          List<Map<String, dynamic>> absentOneSignal = [];
                          absentStudentMap.forEach((element) {
                            absentOneSignal.add({
                              'id': authProvider
                                  .oneSignalId(element['parent_id']),
                              'name': element['name']
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
                                                .of<StudentAttendanceProvider>(
                                                    context,
                                                    listen: false);
                                            var newAttendance =
                                                StudentAttendanceModel(
                                                    id: DateTime.now()
                                                        .toString(),
                                                    dateTime: DateTime.now()
                                                        .toString(),
                                                    standard: widget.standard,
                                                    teacherId: currentUser ==
                                                            null
                                                        ? ''
                                                        : currentUser!.roleId,
                                                    presentChildren:
                                                        presentStudentMap,
                                                    absentChildren:
                                                        absentStudentMap);
                                            attendanceProvider
                                                .addStudentAttendance(
                                                    newAttendance)
                                                .catchError((error) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              s(() {
                                                isLoading = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Somethineg went wrong'),
                                              ));
                                            }).then((value) async {
                                              absentOneSignal
                                                  .forEach((element) async {
                                                await sendNotification(
                                                    'Your Child ${element['name']} is marked absent today',
                                                    'Absent Alert',
                                                    [element['id']]);
                                              });

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
