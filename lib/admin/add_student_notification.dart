import 'package:flutter/material.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class SelectStudent extends StatefulWidget {
  final String standard;
  const SelectStudent({Key? key, required this.standard}) : super(key: key);

  @override
  _SelectStudentState createState() => _SelectStudentState();
}

class _SelectStudentState extends State<SelectStudent> {
  List<StudentModel> selectedStudent = [];
  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();

  String title = '';
  String content = '';
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    var studentProvider = Provider.of<StudentProvider>(context);
    List<StudentModel> students = studentProvider.students;
    List<StudentModel> filterStudent = students.where((e) {
      return e.standard == widget.standard;
    }).toList();
    return Scaffold(
      appBar: getAppBar('Select Students', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
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
                                      : selectedStudent
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
                      getBoldText('Add Notification', 15, MyColors.blueColor),
                      TextFormField(
                        controller: t1,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.text_fields,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter title',
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          title = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: t2,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Content',
                          labelText: 'Content',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          content = newValue!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getNormalText('Notify', 14, Colors.white),
                          onPressed: () async {
                            List<String> onesignalids = [];
                            var authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              selectedStudent.forEach((element) {
                                onesignalids.add(
                                    authProvider.oneSignalId(element.parentId));
                              });
                              setState(() {});
                              _formKey.currentState!.save();
                              await sendNotification(
                                  content, title, onesignalids);

                              setState(() {
                                isLoading = false;
                              });
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
