import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/model/homework_model.dart';
import 'package:narayandas_app/provider/homework_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddHomework extends StatefulWidget {
  final String standard;
  const AddHomework({Key? key, required this.standard}) : super(key: key);

  @override
  _AddHomeworkState createState() => _AddHomeworkState();
}

class _AddHomeworkState extends State<AddHomework> {
  String homeworkText = '';
  String remark = '';
  String subject = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? file;
  UploadTask? task;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Add Homework', context),
      body: SingleChildScrollView(
        child: isLoading
            ? getLoading(context)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getBoldText(widget.standard, 15, Colors.black),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getNormalText(
                            formatDateTime(DateTime.now().toString()),
                            14,
                            MyColors.blueColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: t1,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.home_work,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter homework',
                          labelText: 'Homework',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          homeworkText = newValue!;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: t3,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.border_color,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Subject',
                          labelText: 'Subject',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          subject = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: t2,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.border_color,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Remark',
                          labelText: 'Remark',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          remark = newValue!;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5),
                            child: getBoldText(
                                'Add Image', 14, MyColors.blueColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: getNormalText(
                                  file == null ? '' : file!.name,
                                  12,
                                  Colors.black),
                            ),
                            file == null
                                ? Container()
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        file = null;
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                          ],
                        ),
                      ),
                      file == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      selectImageCamera();
                                    },
                                    child: getNormalText(
                                        'Camera', 14, Colors.blue)),
                                GestureDetector(
                                    onTap: () {
                                      selectImageGallery();
                                    },
                                    child: getNormalText(
                                        'Gallery', 14, Colors.blue)),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: MyColors.blueColor,
                        shape: StadiumBorder(),
                        child: getBoldText('Upload Homework', 13, Colors.white),
                        onPressed: () {
                          file == null ? saveForm('') : uploadImage();
                        },
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // Future selectFile() async {
  //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  //   if (result == null) return;
  //   final path = result.files.single.path;
  //   setState(() {
  //     file = File(path!);
  //   });
  // }
  Future selectImageCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      file = XFile(photo!.path);
    });
  }

  Future selectImageGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = XFile(photo!.path);
    });
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    File? newFile;

    if (file == null) return;
    newFile = File(file!.path);
    final dest = 'homework_images/${file!.name}';
    task = FirebaseApi.uploadFile(dest, newFile);
    if (task == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final snapshot = await task!.whenComplete(() {
      setState(() {
        file = null;

        isLoading = false;
      });
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    saveForm(urlDownload);
  }

  saveForm(String url) {
    var homeworkProvider =
        Provider.of<HomeworkProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      var newHomework = HomeworkModel(
          id: DateTime.now().toString(),
          standard: widget.standard,
          dateTime: DateTime.now().toString(),
          homeworktext: homeworkText,
          subject: subject,
          imgUrl: url,
          teacherId: '',
          remark: remark);
      homeworkProvider.addHomework(newHomework).catchError((error) {
        setState(() {
          isLoading = false;
        });
        return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Somethineg went wrong'),
        ));
      }).then((value) {
        setState(() {
          // meals.add(newMeal);
          isLoading = false;
          t1.clear();
          t2.clear();
          t3.clear();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Homework Uploaded'),
          ));
          // _showMyDialog();
        });

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => AddFees(
        //       parentModel:
        //           Provider.of<ParentsProvider>(context)
        //               .parents[0],
        //     ),
        //   ),
        // );
      });
    }
  }
}
