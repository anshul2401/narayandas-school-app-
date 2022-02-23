import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_attendance.dart';
import 'package:narayandas_app/admin/add_homework.dart';
import 'package:narayandas_app/admin/add_student_notification.dart';
import 'package:narayandas_app/admin/promote_student.dart';
import 'package:narayandas_app/admin/view_attendance.dart';
import 'package:narayandas_app/admin/view_homework.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';

class SelectClass extends StatefulWidget {
  final bool isHomework;
  final bool isViewHomework;
  final bool isPromotion;
  final bool isViewAttendance;
  final bool isAddNotification;
  const SelectClass({
    Key? key,
    required this.isHomework,
    required this.isViewHomework,
    required this.isPromotion,
    required this.isViewAttendance,
    required this.isAddNotification,
  }) : super(key: key);

  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {
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
    return Scaffold(
      appBar: getAppBar('Select class', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              physics: ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 2,
              ),
              shrinkWrap: true,
              itemCount: standardList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.isViewAttendance
                        ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                ViewAttendance(standard: standardList[index])))
                        : widget.isHomework
                            ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) =>
                                    AddHomework(standard: standardList[index])))
                            : widget.isViewHomework
                                ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => ViewHomework(
                                        standard: standardList[index])))
                                : widget.isPromotion
                                    ? Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => PromoteStudent(
                                                standard: standardList[index])))
                                    : widget.isAddNotification
                                        ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                                            builder: (context) => SelectStudent(
                                                standard: standardList[index])))
                                        : Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => AddAttendance(standard: standardList[index])));
                  },
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: getBoldText(
                        standardList[index],
                        15,
                        MyColors.blueColor,
                      ),
                    ),
                  )),
                );
              }),
        ),
      ),
    );
  }
}
