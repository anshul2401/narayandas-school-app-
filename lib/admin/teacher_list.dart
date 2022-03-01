import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_fees.dart';
import 'package:narayandas_app/admin/edit_teacher.dart';
import 'package:narayandas_app/admin/view_teacher_details.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class TeacherList extends StatefulWidget {
  const TeacherList({Key? key}) : super(key: key);

  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<TeacherProvider>(context, listen: false)
        .fetAndSetTeachers()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var teachersProvider = Provider.of<TeacherProvider>(context, listen: false);
    List<TeacherModel> teachers = teachersProvider.teacher.toList();
    return Scaffold(
      appBar: getAppBar('Teachers List', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: teachers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         AddFees(parentModel: parents[index])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      height: 60,
                                      child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/narayandas-school-app.appspot.com/o/profile_images%2Fdownload.png?alt=media&token=08c984c3-7bb6-43a1-b5c7-1723d607726c'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getBoldText(teachers[index].name, 15,
                                          Colors.black),
                                      getNormalText(teachers[index].phone, 13,
                                          Colors.grey),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewTeacherDetails(
                                                          teacherModel:
                                                              teachers[
                                                                  index])));
                                        },
                                        child: getNormalText(
                                            'View Profile', 14, Colors.blue),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  getButton(() {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditTeacher(
                                                  teacherModel: teachers[index],
                                                )));
                                  }, 'Edit', Colors.green),
                                ],
                              ),
                            ),
                          ),
                        ));
                  }),
            ),
    );
  }
}
