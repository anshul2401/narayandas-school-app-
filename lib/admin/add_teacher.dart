import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  String name = '';
  String email = '';
  String password = '';
  String address = '';
  String mobileNumber = '';
  String docName = '';
  late List<Map<String, String>> documents = [];
  XFile? file;
  UploadTask? task;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  TextEditingController t5 = TextEditingController();
  TextEditingController t1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();
    return Scaffold(
      appBar: getAppBar('Add Teacher', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBoldText('Enter Details', 16, MyColors.blueColor),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter full name',
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          name = newValue!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.map,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter address',
                          labelText: 'Address',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          address = newValue!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter a phone number',
                          labelText: 'Phone',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          mobileNumber = newValue!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      getBoldText('Upload Documents', 16, MyColors.blueColor),
                      documents.isNotEmpty
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: documents.length,
                              itemBuilder: (context, indexx) {
                                return Row(
                                  children: [
                                    getNormalText(
                                        documents[indexx]['doc_name']!,
                                        15,
                                        Colors.black),
                                  ],
                                );
                              })
                          : Container(
                              height: 0,
                            ),
                      Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    docName = newValue!;
                                  },
                                  controller: t5,
                                  decoration: InputDecoration(
                                      hintText: "Document name"),
                                ),
                                file == null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          children: [
                                            file == null
                                                ? Container()
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    child: getNormalText(
                                                        file!.name,
                                                        12,
                                                        Colors.black),
                                                  ),
                                            file == null
                                                ? Container(
                                                    height: 0,
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        file = null;
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete))
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                      ),
                                file == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                    : Container(
                                        height: 0,
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _formKey2.currentState!.save();
                          uploadImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getNormalText('Add Document', 14, Colors.lightBlue)
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      getBoldText(
                        'Create Email Id and Password',
                        16,
                        MyColors.blueColor,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter email id',
                          labelText: 'Email Id',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          email = newValue!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Password',
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          password = newValue!;
                        },
                      ),
                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     icon: Icon(
                      //       Icons.money,
                      //       color: MyColors.blueColor,
                      //     ),
                      //     hintText: 'Enter total fees',
                      //     labelText: 'Total Fees',
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please enter some value';
                      //     }
                      //     return null;
                      //   },
                      //   onSaved: (newValue) {
                      //     totalFees = int.parse(newValue!);
                      //   },
                      // ),

                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getBoldText(
                            'Add Teacher',
                            15,
                            Colors.white,
                          ),
                          onPressed: () {
                            var teacherProvider = Provider.of<TeacherProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey.currentState!.save();
                              var newTeacher = TeacherModel(
                                id: DateTime.now().toString(),
                                email: email,
                                password: password,
                                name: name,
                                address: address,
                                phone: mobileNumber,
                                oneSignalId: '',
                                document: documents,
                                datetime: DateTime.now().toString(),
                                isBlocked: false,
                              );
                              teacherProvider
                                  .addTeacher(newTeacher)
                                  .catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Somethineg went wrong'),
                                ));
                              }).then((value) {
                                setState(() {
                                  isLoading = false;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Teacher Added'),
                                  ));
                                });

                                Navigator.of(context).pop();
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
    final dest = 'teacher_docs/${file!.name}';
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
    var document = {
      'doc_name': docName,
      'doc_img': urlDownload,
    };
    setState(() {
      documents.add(document);
      t5.clear();
    });
    // saveForm(urlDownload);
  }
}
