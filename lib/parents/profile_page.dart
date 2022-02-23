import 'package:flutter/material.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<StudentProvider>(context, listen: false)
          .fetchAndSetStudents()
          .then((value) {});
    });
    Future.delayed(Duration.zero).then((value) {
      Provider.of<ParentsProvider>(context, listen: false)
          .fetchAndSetParents()
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
    List<StudentModel> students = [];
    late ParentModel parentModel;
    var studentProvider = Provider.of<StudentProvider>(context, listen: false);

    students.addAll(studentProvider.students.where((element) {
      return element.parentId == currentUser!.roleId;
    }));

    var parentProvider = Provider.of<ParentsProvider>(context, listen: false);
    parentModel =
        parentProvider.parents.firstWhere((e) => e.id == currentUser!.roleId);

    return Scaffold(
      appBar: getAppBar('Profile', context),
      body: isLoading
          ? getLoading(context)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getDetailContainer('Father\'s Name', parentModel.fatherName),
                  getDetailContainer('Mother\'s Name', parentModel.fatherName),
                  getDetailContainer('Address', parentModel.address),
                  getDetailContainer('Mobile number', parentModel.phoneNumber),
                  getDetailContainer('Email', parentModel.email),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getBoldCaptialText(
                          'Children\'s Details', 15, MyColors.blueColor),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: parentModel.children.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getDetailContainer(
                                    'Name', parentModel.children[index].name),
                                getDetailContainer('Class',
                                    parentModel.children[index].standard),
                              ],
                            ),
                            Divider(),
                          ],
                        );
                      }),
                ],
              ),
            ),
    );
  }

  getDetailContainer(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getBoldCaptialText(title, 15, MyColors.blueColor),
          SizedBox(
            height: 2,
          ),
          getNormalText(content, 15, Colors.black),
        ],
      ),
    );
  }
}
