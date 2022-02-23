import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/admin/add_fees.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddStudent extends StatefulWidget {
  final ParentModel parentModel;
  const AddStudent({Key? key, required this.parentModel}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool isLoading = false;
  List<ChildModel> children = [];
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final TextEditingController _textFieldController3 = TextEditingController();
  final TextEditingController _textFieldController4 = TextEditingController();
  final TextEditingController _textFieldController5 = TextEditingController();
  final TextEditingController _textFieldController6 = TextEditingController();
  final TextEditingController _textFieldController7 = TextEditingController();
  late String studentName;
  late String dob;
  late String bloodGroup;
  String? standard;
  late String docName;
  late String docImg;
  String? gender;
  late List<Map<String, String>> documents = [];
  XFile? file;
  UploadTask? task;
  final ImagePicker _picker = ImagePicker();
  var _form = GlobalKey<FormState>();
  var _form2 = GlobalKey<FormState>();

  List<String> standardList = [
    'PPlay Group',
    'Nursery',
    'LKG',
    'UKG',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
  ];
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
    final dest = 'student_docs/${file!.name}';
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
      _form2.currentState!.reset();
      _textFieldController5.clear();
      // ChildModel child = children.firstWhere((element) {
      //   return element.name == name;
      // });
      // var docs = child.documents;
      // docs.add(document);

      // children[children.indexWhere((element) => element.name == name)] =
      //     ChildModel(
      //         name: child.name,
      //         standard: child.standard,
      //         documents: docs,
      //         bloodGroup: child.bloodGroup,
      //         dob: child.dob,
      //         gender: child.gender);

      // _textFieldController5.clear();
    });

    // saveForm(urlDownload);
  }

  @override
  void initState() {
    children = widget.parentModel.children;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Add Student Details', context),
      body: isLoading
          ? getLoading(context)
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: children.length,
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getBoldText((index + 1).toString(), 14,
                                        Colors.black),
                                    getNormalText(
                                        children[index].name, 14, Colors.black),
                                    getNormalText(children[index].standard, 14,
                                        Colors.black),
                                  ],
                                ));
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          getBoldText(
                              'Add child details', 16, MyColors.blueColor),
                        ],
                      ),
                      TextFormField(
                        controller: _textFieldController,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Name',
                          labelText: 'Enter Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          studentName = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: _textFieldController2,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_today,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'DOB',
                          labelText: 'Enter DOB',
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          dob = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: _textFieldController3,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.bloodtype,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Blood Group',
                          labelText: 'Enter Blood Group',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          bloodGroup = newValue!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 36,
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                                color: MyColors.blueColor,
                                borderRadius: BorderRadius.circular(10)),

                            // dropdown below..
                            child: DropdownButton<String>(
                              alignment: Alignment.bottomCenter,
                              hint:
                                  getBoldTextCenter('Class', 14, Colors.white),
                              value: standard,
                              onChanged: (String? newValue) =>
                                  setState(() => standard = newValue),
                              dropdownColor:
                                  MyColors.blueColor.withOpacity(0.8),
                              items: standardList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: getBoldTextCenter(
                                                value, 14, Colors.white),
                                          ))
                                  .toList(),

                              // add extra sugar..
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              // iconSize: ,
                              underline: SizedBox(),
                            ),
                          ),
                          Container(
                            height: 36,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            decoration: BoxDecoration(
                                color: MyColors.blueColor,
                                borderRadius: BorderRadius.circular(10)),

                            // dropdown below..
                            child: DropdownButton<String>(
                              alignment: Alignment.bottomCenter,
                              hint:
                                  getBoldTextCenter('Gender', 14, Colors.white),
                              value: gender,
                              onChanged: (String? newValue) =>
                                  setState(() => gender = newValue),
                              dropdownColor:
                                  MyColors.blueColor.withOpacity(0.8),
                              items: ['Male', 'Female']
                                  .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: getBoldTextCenter(
                                                value, 14, Colors.white),
                                          ))
                                  .toList(),

                              // add extra sugar..
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              // iconSize: ,
                              underline: SizedBox(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          getBoldText(
                              'Upload Documents', 16, MyColors.blueColor),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          itemCount: documents.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return getBoldText(documents[index]['doc_name']!,
                                15, Colors.black);
                          }),
                      Form(
                        key: _form2,
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
                              controller: _textFieldController5,
                              decoration:
                                  InputDecoration(hintText: "Document name"),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            file == null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Image.file(File(file!.path)),
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
                                                  BorderRadius.circular(3),
                                            ),
                                            child: getBoldText(
                                                'Camera', 14, Colors.white),
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
                                                  BorderRadius.circular(3),
                                            ),
                                            child: getBoldText(
                                                'Gallery', 14, Colors.white),
                                          )),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            // RaisedButton(
                            //   color: MyColors.blueColor,
                            //   shape: StadiumBorder(),
                            //   child: getBoldText('Upload Homework', 13, Colors.white),
                            //   onPressed: () {
                            //     uploadImage();
                            //   },
                            // )
                            GestureDetector(
                              onTap: () {
                                _form2.currentState!.save();
                                uploadImage();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getNormalText(
                                      'Add Document', 14, Colors.lightBlue)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: Colors.green,
                          child: getBoldText(
                            'Add Child',
                            15,
                            Colors.white,
                          ),
                          onPressed: () {
                            if (_form.currentState!.validate()) {
                              _form.currentState!.save();
                              setState(
                                () {
                                  children.add(
                                    ChildModel(
                                      name: studentName,
                                      standard: standard!,
                                      documents: documents,
                                      bloodGroup: bloodGroup,
                                      dob: dob,
                                      gender: gender!,
                                    ),
                                  );
                                },
                              );
                              var newParent = ParentModel(
                                id: DateTime.now().toString(),
                                email: widget.parentModel.email,
                                password: widget.parentModel.password,
                                fatherName: widget.parentModel.fatherName,
                                motherName: widget.parentModel.motherName,
                                address: widget.parentModel.address,
                                phoneNumber: widget.parentModel.phoneNumber,
                                oneSignalId: '',
                                totalFee: widget.parentModel.totalFee,
                                children: children,
                                fees: [],
                                dateTime: DateTime.now().toString(),
                                isBlocked: false,
                                feeBreakdown: widget.parentModel.feeBreakdown,
                              );
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddStudent(
                                            parentModel: newParent,
                                          )));
                            }
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                            shape: StadiumBorder(),
                            color: MyColors.blueColor,
                            child: getBoldText(
                              'Save and Continue',
                              15,
                              Colors.white,
                            ),
                            onPressed: () {
                              var parentProvider = Provider.of<ParentsProvider>(
                                  context,
                                  listen: false);

                              setState(() {
                                isLoading = true;
                              });

                              var newParent = ParentModel(
                                id: DateTime.now().toString(),
                                email: widget.parentModel.email,
                                password: widget.parentModel.password,
                                fatherName: widget.parentModel.fatherName,
                                motherName: widget.parentModel.motherName,
                                address: widget.parentModel.address,
                                phoneNumber: widget.parentModel.phoneNumber,
                                oneSignalId: '',
                                totalFee: widget.parentModel.totalFee,
                                children: children,
                                fees: [],
                                feeBreakdown: widget.parentModel.feeBreakdown,
                                dateTime: DateTime.now().toString(),
                                isBlocked: false,
                              );
                              parentProvider
                                  .addParent(newParent)
                                  .catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Somethineg went wrong'),
                                ));
                              }).then((value) {
                                setState(() {
                                  isLoading = false;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Data Added'),
                                  ));
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => AddFees(
                                        parentModel:
                                            Provider.of<ParentsProvider>(
                                                    context)
                                                .parents[0],
                                      ),
                                    ),
                                  );
                                });
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
