import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_meal.dart';
import 'package:narayandas_app/admin/add_student.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/approve_fees.dart';
import 'package:narayandas_app/admin/parents_list.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/provider/homework_provider.dart';
import 'package:narayandas_app/provider/meal_provider.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminHomePage> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<ParentsProvider>(context, listen: false)
          .fetchAndSetParents()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<FeesProvider>(context, listen: false)
          .fetAndSetFees()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<StudentProvider>(context, listen: false)
          .fetchAndSetStudents()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<MealProvider>(context, listen: false)
          .fetAndSetMeal()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
      Provider.of<HomeworkProvider>(context, listen: false)
          .fetAndSetHomework()
          .then((value) {
        // setState(() {
        //   isLoading = false;
        // });
      });
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
    return Scaffold(
      appBar: getAppBar('Welcome Admin', context),
      body: isLoading
          ? getLoading(context)
          : Column(
              children: [
                RaisedButton(
                    child: Text('Add Student'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddStudent()));
                    }),
                RaisedButton(
                    child: Text('All Parents'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParentsList()));
                    }),
                RaisedButton(
                    child: Text('Add Fees'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddStudent()));
                    }),
                RaisedButton(
                    child: Text('Add teacher'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTeacher()));
                    }),
                RaisedButton(
                    child: Text('Add meal and meal list '),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddMeal()));
                    }),
                RaisedButton(
                    child: Text('Fees List and approve'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ApproveFees()));
                    }),
                RaisedButton(
                    child: Text('Add attendace'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectClass(
                                    isHomework: false,
                                    isViewHomework: false,
                                  )));
                    }),
                RaisedButton(
                    child: Text('Teacher List'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherList()));
                    }),
                RaisedButton(
                    child: Text('Add teacher attendance'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddTeacherAttendance()));
                    }),
                RaisedButton(
                    child: Text('Add homework'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectClass(
                                    isHomework: true,
                                    isViewHomework: false,
                                  )));
                    }),
                RaisedButton(
                    child: Text('View homework'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectClass(
                                    isHomework: false,
                                    isViewHomework: true,
                                  )));
                    }),
                RaisedButton(
                    child: Text('View meal'),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewMeal()));
                    }),
              ],
            ),
    );
  }
}
