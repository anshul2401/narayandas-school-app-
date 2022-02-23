import 'package:flutter/material.dart';
import 'package:narayandas_app/model/notice_model.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/provider/notice_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddNotice extends StatefulWidget {
  const AddNotice({Key? key}) : super(key: key);

  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String title = '';
  String content = '';
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<NoticeProvider>(context, listen: false)
        .fetchAndSetNotice()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<NoticeModel> notice = [];
    var noticeProvider = Provider.of<NoticeProvider>(context);
    notice = noticeProvider.notice;
    return Scaffold(
      appBar: getAppBar('Notice', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: notice.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: getNormalText(
                                              notice[index].title,
                                              15,
                                              MyColors.blueColor),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: getNormalText(
                                              notice[index].content,
                                              13,
                                              Colors.black),
                                        )
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          var noticeProvider =
                                              Provider.of<NoticeProvider>(
                                                  context,
                                                  listen: false);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await noticeProvider
                                              .deleteNotice(notice[index].id);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Add Notice', 15, MyColors.blueColor),
                      TextFormField(
                        controller: t1,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.text_fields,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter title',
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          title = newValue!;
                        },
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: t2,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Content',
                          labelText: 'Content',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          content = newValue!;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getBoldText(
                            'Add Notice',
                            15,
                            Colors.white,
                          ),
                          onPressed: () async {
                            var noticeProvider = Provider.of<NoticeProvider>(
                                context,
                                listen: false);
                            var authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              noticeProvider
                                  .addNotice(NoticeModel(
                                      id: 'a',
                                      title: title,
                                      content: content,
                                      datetime: DateTime.now().toString()))
                                  .catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Somethineg went wrong'),
                                ));
                              }).then((value) async {
                                await sendNotification(content, title,
                                    authProvider.teacherOneSignalIds());

                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(' Notice Added Successfully'),
                                ));
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
