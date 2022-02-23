import 'package:flutter/material.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({Key? key}) : super(key: key);

  @override
  _AddNotificationState createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String title = '';
  String content = '';
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  bool sendToParent = false;
  bool sendToTeacher = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Notification', context),
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
                      getBoldText('Add Notification', 15, MyColors.blueColor),
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
                        controller: t2,
                        keyboardType: TextInputType.text,
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
                        height: 20,
                      ),
                      getBoldText('Select audience', 15, MyColors.blueColor),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendToParent = !sendToParent;
                              });
                            },
                            child: Row(
                              children: [
                                sendToParent
                                    ? Icon(Icons.check_box_outlined)
                                    : Icon(Icons.check_box_outline_blank),
                                getNormalText('Parents', 15, Colors.black),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendToTeacher = !sendToTeacher;
                              });
                            },
                            child: Row(
                              children: [
                                sendToTeacher
                                    ? Icon(Icons.check_box_outlined)
                                    : Icon(Icons.check_box_outline_blank),
                                getNormalText('Teachers', 15, Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getBoldText(
                            'Send notification',
                            15,
                            Colors.white,
                          ),
                          onPressed: () async {
                            var authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey.currentState!.save();
                              sendToParent
                                  ? await sendNotification(content, title,
                                      authProvider.parentOneSignalIds())
                                  : null;
                              sendToTeacher
                                  ? await sendNotification(content, title,
                                      authProvider.teacherOneSignalIds())
                                  : null;
                              setState(() {
                                isLoading = false;
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
