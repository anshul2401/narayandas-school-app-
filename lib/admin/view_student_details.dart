import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/view_full_screenImg.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class ViewStudentDetails extends StatefulWidget {
  final StudentModel studentModel;
  const ViewStudentDetails({Key? key, required this.studentModel})
      : super(key: key);

  @override
  _ViewStudentDetailsState createState() => _ViewStudentDetailsState();
}

class _ViewStudentDetailsState extends State<ViewStudentDetails> {
  late ParentModel parentModel;
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<ParentsProvider>(context, listen: false)
        .fetchAndSetParents()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    var parentProvider = Provider.of<ParentsProvider>(context, listen: false);
    parentModel = parentProvider.parents.firstWhere((element) {
      return element.id == widget.studentModel.parentId;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Details', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getDetailContainer('Name', widget.studentModel.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getDetailContainer('Standard', widget.studentModel.standard),
                  getDetailContainer('Gender', widget.studentModel.gender),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getDetailContainer('DOB', widget.studentModel.dob),
                  getDetailContainer(
                      'Blood Group', widget.studentModel.bloodGroup),
                ],
              ),
              getDetailContainer('Father name', parentModel.fatherName),
              getDetailContainer('Mother name', parentModel.motherName),
              getDetailContainer('Address', parentModel.address),
              getDetailContainer('Mobile', parentModel.phoneNumber),
              getBoldCaptialText('Documents', 15, MyColors.blueColor),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.studentModel.documents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                                imgUrl: widget.studentModel.documents[index]
                                    ['doc_img']!)));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getNormalText(
                            widget.studentModel.documents[index]['doc_name']!,
                            13,
                            Colors.black,
                          ),
                          Container(
                            height: 200,
                            child: Image.network(
                              widget.studentModel.documents[index]['doc_img']!,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  getDetailContainer(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
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
