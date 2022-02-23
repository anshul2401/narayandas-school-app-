import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/account.dart';
import 'package:narayandas_app/admin/add_parent_details.dart';
import 'package:narayandas_app/admin/add_teacher.dart';
import 'package:narayandas_app/admin/add_teacher_attendance.dart';
import 'package:narayandas_app/admin/approve_fees.dart';
import 'package:narayandas_app/admin/search_parent.dart';
import 'package:narayandas_app/admin/search_student.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/admin/view_teacher_attendance.dart';
import 'package:narayandas_app/utils/helper.dart';

class AccountPanel extends StatefulWidget {
  const AccountPanel({Key? key}) : super(key: key);

  @override
  _AccountPanelState createState() => _AccountPanelState();
}

class _AccountPanelState extends State<AccountPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar('Manage Account', context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getActionCard(
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
              getActionCard(
                'approve_fees.png',
                'Approve Fees',
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ApproveFees()));
                },
              ),
              getActionCard(
                'approve_fees.png',
                'Manage Account',
                () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Account()));
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
