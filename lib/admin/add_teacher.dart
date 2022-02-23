import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool canEditMeal = false;
  bool canAddFees = false;
  bool canAddStudent = false;
  bool canAddGallery = false;
  bool canPromoteClass = false;

  @override
  Widget build(BuildContext context) {
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
                        controller: t1,
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
                        controller: t2,
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
                        controller: t3,
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
                      SizedBox(
                        height: 10,
                      ),
                      documents.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
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
                                  }),
                            )
                          : Container(
                              height: 0,
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  file != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Image.file(
                                                    File(file!.path)),
                                              ),
                                              IconButton(
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
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                  child: getBoldText('Camera',
                                                      14, Colors.white),
                                                )),
                                            GestureDetector(
                                                onTap: () {
                                                  selectImageGallery();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                  child: getBoldText('Gallery',
                                                      14, Colors.white),
                                                )),
                                          ],
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _formKey2.currentState!.save();
                                      uploadImage();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getNormalText('Add Document', 14,
                                            Colors.lightBlue)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
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
                      SizedBox(
                        height: 10,
                      ),
                      getSwitchButton(
                        (val) {
                          setState(() {
                            canEditMeal = val;
                          });
                        },
                        'Edit Meal',
                        canEditMeal,
                      ),
                      getSwitchButton(
                        (val) {
                          setState(() {
                            canAddFees = val;
                          });
                        },
                        'Add Fees',
                        canAddFees,
                      ),
                      getSwitchButton(
                        (val) {
                          setState(() {
                            canAddStudent = val;
                          });
                        },
                        'Add Student',
                        canAddStudent,
                      ),
                      getSwitchButton(
                        (val) {
                          setState(() {
                            canAddGallery = val;
                          });
                        },
                        'Add Gallery',
                        canAddGallery,
                      ),
                      getSwitchButton(
                        (val) {
                          setState(() {
                            canPromoteClass = val;
                          });
                        },
                        'Promote Class',
                        canPromoteClass,
                      ),

                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10.0),
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
                                canAddFees: canAddFees,
                                canAddGallery: canAddGallery,
                                canAddStudent: canAddStudent,
                                canEditMeal: canEditMeal,
                                canPromoteClass: canPromoteClass,
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

  getSwitchButton(var voidCallback, String title, bool status) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getBoldText(title, 14, Colors.black),
          FlutterSwitch(
            activeColor: MyColors.blueColor,
            width: 50.0,
            height: 22.0,
            valueFontSize: 10.0,
            toggleSize: 18.0,
            value: status,
            borderRadius: 30.0,
            padding: 3,
            showOnOff: true,
            onToggle: voidCallback,
          ),
        ],
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
      _formKey2.currentState!.reset();
      t5.clear();
    });
    // saveForm(urlDownload);
  }
}
