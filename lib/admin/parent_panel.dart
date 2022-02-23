import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_parent_details.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/search_parent.dart';
import 'package:narayandas_app/admin/search_student.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/admin/view_teacher_attendance.dart';
import 'package:narayandas_app/utils/helper.dart';

class ParentPanel extends StatefulWidget {
  const ParentPanel({Key? key}) : super(key: key);

  @override
  _ParentPanelState createState() => _ParentPanelState();
}

class _ParentPanelState extends State<ParentPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar('Parent Panel', context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getActionCard(
                'edit_teacher.png',
                'Edit Parent',
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchParent(isEdit: true)));
                },
              ),
            ],
          ),
        ));
  }

  getActionCard(String imgUrl, String title, VoidCallback callback) {
    return Card(
        child: ListTile(
      onTap: callback,
      leading: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
            width: 40, height: 40, child: Image.asset('assets/images/$imgUrl')),
      ),
      title: Center(child: getBoldText(title, 15, Colors.black)),
    ));
  }
}
