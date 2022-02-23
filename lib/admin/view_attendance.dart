import 'package:flutter/material.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class ViewAttendance extends StatefulWidget {
  final String standard;
  const ViewAttendance({Key? key, required this.standard}) : super(key: key);

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  DateTime date = DateTime.now();

  bool isLoading = false;

  List<StudentAttendanceModel> attendance = [];
  StudentAttendanceModel? todayAttendance;
  bool isTaken = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<StudentAttendanceProvider>(context, listen: false)
        .fetAndSetStudentAttendance()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    var st = Provider.of<StudentAttendanceProvider>(context, listen: false);
    attendance.addAll(st.studentAttendance);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAttendance() {
      var st;
      attendance.forEach((element) {
        if (formatDateTime(element.dateTime) ==
                formatDateTime(date.toString()) &&
            element.standard == widget.standard) {
          st = element;
        }
      });
      return st;
    }

    todayAttendance = getAttendance();
    return Scaffold(
      appBar: getAppBar('View attendance', context),
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
                                    'PRESENT STUDENTS', 15, MyColors.blueColor),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      todayAttendance!.presentChildren.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        todayAttendance!.presentChildren[index];
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
                                    'ABSENT STUDENTS', 15, MyColors.blueColor),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      todayAttendance!.absentChildren.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        todayAttendance!.absentChildren[index];
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
