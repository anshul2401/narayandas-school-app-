import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_fees.dart';
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
  @override
  Widget build(BuildContext context) {
    var teachersProvider = Provider.of<TeacherProvider>(context, listen: false);
    List<TeacherModel> teachers = teachersProvider.teacher.toList();
    return Scaffold(
      appBar: getAppBar('Teachers List', context),
      body: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) =>
                    //         AddFees(parentModel: parents[index])));
                  },
                  child: getBoldText(teachers[index].name, 13, Colors.black));
            }),
      ),
    );
  }
}
