import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/view_full_screenImg.dart';
import 'package:narayandas_app/model/homework_model.dart';
import 'package:narayandas_app/provider/homework_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class ViewHomework extends StatefulWidget {
  final String standard;
  const ViewHomework({Key? key, required this.standard}) : super(key: key);

  @override
  _ViewHomeworkState createState() => _ViewHomeworkState();
}

class _ViewHomeworkState extends State<ViewHomework> {
  List<HomeworkModel> homework = [];
  DateTime date = DateTime.now();
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<HomeworkProvider>(context, listen: false)
        .fetAndSetHomework()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeworkProvider = Provider.of<HomeworkProvider>(context);
    homework = homeworkProvider.homework.where((element) {
      return element.standard == widget.standard;
    }).toList();
    List<HomeworkModel> selectedDateHomework = homework.where((e) {
      return formatDateTime(e.dateTime) == formatDateTime(date.toString());
    }).toList();
    return Scaffold(
      appBar: getAppBar('Homework', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getBoldText(widget.standard, 14, MyColors.blueColor),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getNormalText(
                            formatDateTime(date.toString()), 13, Colors.black),
                        IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            icon: Icon(Icons.calendar_today))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    selectedDateHomework.isEmpty
                        ? getEmptyHereMsg()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: selectedDateHomework.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getBoldText(
                                      selectedDateHomework[index].subject,
                                      15,
                                      Colors.black),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  getNormalText(
                                      selectedDateHomework[index].homeworktext,
                                      14,
                                      Colors.black),
                                  getNormalText(
                                      '(${selectedDateHomework[index].remark})',
                                      13,
                                      Colors.grey),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullScreenImage(
                                                          imgUrl:
                                                              selectedDateHomework[
                                                                      index]
                                                                  .imgUrl)));
                                        },
                                        child: Container(
                                          height: 200,
                                          child: Image.network(
                                            selectedDateHomework[index].imgUrl,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider()
                                ],
                              );
                            })
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(DateTime.now().year + 1));
    if (picked != date)
      setState(() {
        date = picked!;
      });
  }
}
