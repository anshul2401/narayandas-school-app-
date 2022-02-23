import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_fees.dart';
import 'package:narayandas_app/admin/edit_parent.dart';
import 'package:narayandas_app/admin/view_student_details.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/search_widget.dart';
import 'package:provider/provider.dart';

class SearchStudent extends StatefulWidget {
  final bool isEdit;
  const SearchStudent({Key? key, required this.isEdit}) : super(key: key);

  @override
  SearchStudentState createState() => SearchStudentState();
}

class SearchStudentState extends State<SearchStudent> {
  List<StudentModel> students = [];
  String query = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((value) {
      Provider.of<StudentProvider>(context, listen: false)
          .fetchAndSetStudents()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });

    var studentProvider = Provider.of<StudentProvider>(context, listen: false);
    students = studentProvider.students;
  }

  @override
  Widget build(BuildContext context) {
    // var productProvider = Provider.of<Products>(context, listen: false);
    // products = productProvider.products;
    return Scaffold(
      appBar: getAppBar('Search Student', context),
      body: isLoading
          ? getLoading(context)
          : Column(
              children: <Widget>[
                buildSearch(),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return buildProduct(student);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search name or Standard',
        onChanged: searchParent,
      );

  Widget buildProduct(StudentModel studentModel) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey,
              ),
            )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getBoldText(studentModel.name, 15, Colors.black),
                    getNormalText(studentModel.standard, 13, Colors.grey),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewStudentDetails(
                                  studentModel: studentModel,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getNormalText(
                        'View Details',
                        12,
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );

  void searchParent(String query) {
    final books = students.where((studentModel) {
      final nameLower = studentModel.name.toLowerCase();
      final standardLower = studentModel.standard.toLowerCase();

      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          standardLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      students = books;
    });
  }
}
