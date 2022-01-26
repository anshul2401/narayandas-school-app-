import 'package:flutter/material.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class PromoteStudent extends StatefulWidget {
  final String standard;
  const PromoteStudent({Key? key, required this.standard}) : super(key: key);

  @override
  _PromoteStudentState createState() => _PromoteStudentState();
}

class _PromoteStudentState extends State<PromoteStudent> {
  List<StudentModel> selectedStudent = [];
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<StudentProvider>(context, listen: false)
        .fetchAndSetStudents()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  String? standard;

  List<String> standardList = [
    'PPlay Group',
    'Nursery',
    'LKG',
    'UKG',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
  ];

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<StudentProvider>(context);
    List<StudentModel> students = studentProvider.students;
    List<StudentModel> filterStudent = students.where((e) {
      return e.standard == widget.standard;
    }).toList();
    return Scaffold(
      appBar: getAppBar('Promote Students', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
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
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterStudent.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStudent.contains(filterStudent[index])
                                    ? selectedStudent
                                        .remove(filterStudent[index])
                                    : selectedStudent.add(filterStudent[index]);
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
                                    getNormalText(filterStudent[index].name, 14,
                                        Colors.black),
                                    // getNormalText(
                                    //   selectedStudent
                                    //           .contains(filterStudent[index])
                                    //       ? 'P'
                                    //       : '',
                                    //   15,
                                    //   Colors.green,
                                    // ),
                                    selectedStudent
                                            .contains(filterStudent[index])
                                        ? Icon(Icons.check_box)
                                        : Icon(Icons.check_box_outline_blank)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Promote to:', 15, Colors.black),
                          DropdownButton<String>(
                            alignment: Alignment.bottomCenter,
                            focusColor: Colors.white,
                            value: standard,

                            //elevation: 5,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: standardList.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              },
                            ).toList(),
                            hint: Text(
                              "Class",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? value) {
                              setState(
                                () {
                                  standard = value!;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                        shape: StadiumBorder(),
                        color: MyColors.blueColor,
                        child: getNormalText('Update', 14, Colors.white),
                        onPressed: () {
                          var studentProvider = Provider.of<StudentProvider>(
                              context,
                              listen: false);
                          selectedStudent.forEach((element) {
                            setState(() {
                              isLoading = true;
                            });

                            var newStudent = StudentModel(
                                id: element.id,
                                bloodGroup: element.bloodGroup,
                                dob: element.dob,
                                documents: element.documents,
                                gender: element.gender,
                                name: element.name,
                                parentId: element.parentId,
                                standard: standard == null
                                    ? element.standard
                                    : standard!);
                            studentProvider
                                .updateStudent(element.id, newStudent)
                                .catchError((e) {
                              setState(() {
                                isLoading = false;
                              });

                              return ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Somethineg went wrong'),
                              ));
                            }).then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          });

                          // attendanceProvider
                          //     .addStudentAttendance(newAttendance)
                          //     .catchError((error) {
                          //   setState(() {
                          //     isLoading = false;
                          //   });

                          //   return ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text('Somethineg went wrong'),
                          //   ));
                          // }).then((value) {

                          //   setState(() {
                          //     isLoading = false;

                          //   });

                          // });
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
