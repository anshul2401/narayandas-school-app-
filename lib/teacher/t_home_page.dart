import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_student.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/search_parent.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';

class THomePage extends StatefulWidget {
  const THomePage({Key? key}) : super(key: key);

  @override
  _THomePageState createState() => _THomePageState();
}

class _THomePageState extends State<THomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Welcome teacher', context),
      body: Column(
        children: [
          Row(
            children: [
              getActionButton(
                  'add_student_attendance_b.png', 'Add Student attendance', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectClass(
                              isHomework: false,
                              isViewHomework: false,
                              isPromotion: false,
                            )));
              }),
              getActionButton(
                  'add_teacher_attendance_b.png', 'Add Teacher attendance', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTeacherAttendance()));
              }),
              getActionButton('add_homework_b.png', 'Add Homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectClass(
                              isHomework: true,
                              isViewHomework: false,
                              isPromotion: false,
                            )));
              }),
            ],
          ),
          Row(
            children: [
              getActionButton('view_homework_b.png', ' Homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectClass(
                              isHomework: false,
                              isViewHomework: true,
                              isPromotion: false,
                            )));
              }),
              getActionButton('view_meal_b.png', 'Meal', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewMeal()));
              }),
              getActionButton('add_fees_b.png', 'Add Fees', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchParent(
                              isEdit: false,
                            )));
              }),
            ],
          ),
          Row(
            children: [
              getActionButton(
                'new_admission.png',
                ' New Admission',
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddStudent()));
                },
              ),
              getActionButton(
                'add_teacher.png',
                'Add Teacher',
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddTeacher()));
                },
              ),
              getActionButton(
                'add_fees_b.png',
                'Add Fees',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchParent(
                                isEdit: false,
                              )));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getActionButton(
      String imgName, String text, VoidCallback onVoidCallback) {
    return GestureDetector(
      onTap: onVoidCallback,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    'assets/images/$imgName',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 30,
                child: getBoldTextCenter(
                  text,
                  14,
                  Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
