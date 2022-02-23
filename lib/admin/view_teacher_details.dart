import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/admin/print.dart';
import 'package:narayandas_app/admin/view_full_screenImg.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ViewTeacherDetails extends StatefulWidget {
  final TeacherModel teacherModel;
  const ViewTeacherDetails({Key? key, required this.teacherModel})
      : super(key: key);

  @override
  _ViewTeacherDetailsState createState() => _ViewTeacherDetailsState();
}

class _ViewTeacherDetailsState extends State<ViewTeacherDetails> {
  bool isLoading = false;
  bool showAddDocs = false;
  String docName = '';
  late List<Map<String, String>> documents = [];
  XFile? file;
  UploadTask? task;
  final ImagePicker _picker = ImagePicker();
  final pdf = pw.Document();
  @override
  void initState() {
    documents.addAll(widget.teacherModel.document);
    super.initState();
  }

  final _formKey2 = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
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
      t1.clear();
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

  updateTeacherDoc(TeacherModel teacherModel) async {
    var teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await teacherProvider
        .updateTeacher(teacherModel.id, teacherModel)
        .catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Somethineg went wrong'),
      ));
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Updated sucessfully'),
      ));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ViewTeacherDetails(teacherModel: teacherModel)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Details', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getDetailContainer('Name', widget.teacherModel.name),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     getDetailContainer(
                    //         'Standard', widget.studentModel.standard),
                    //     getDetailContainer(
                    //         'Gender', widget.studentModel.gender),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     getDetailContainer('DOB', widget.studentModel.dob),
                    //     getDetailContainer(
                    //         'Blood Group', widget.studentModel.bloodGroup),
                    //   ],
                    // ),
                    // getDetailContainer('Father name', parentModel.fatherName),
                    // getDetailContainer('Mother name', parentModel.motherName),
                    getDetailContainer('Address', widget.teacherModel.address),
                    getDetailContainer('Mobile', widget.teacherModel.phone),
                    getDetailContainer('Email', widget.teacherModel.email),
                    getBoldCaptialText('Documents', 15, MyColors.blueColor),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.teacherModel.document.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                        imgUrl: widget.teacherModel
                                            .document[index]['doc_img']!)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getNormalText(
                                    widget.teacherModel.document[index]
                                        ['doc_name']!,
                                    13,
                                    Colors.black,
                                  ),
                                  Container(
                                    height: 200,
                                    child: Image.network(
                                      widget.teacherModel.document[index]
                                          ['doc_img']!,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    showAddDocs
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        controller: t1,
                                        decoration: InputDecoration(
                                            hintText: "Document name"),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      file != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
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
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                      child: getBoldText(
                                                          'Camera',
                                                          14,
                                                          Colors.white),
                                                    )),
                                                GestureDetector(
                                                    onTap: () {
                                                      selectImageGallery();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                      child: getBoldText(
                                                          'Gallery',
                                                          14,
                                                          Colors.white),
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            updateTeacherDoc(TeacherModel(
                                                id: widget.teacherModel.id,
                                                name: widget.teacherModel.name,
                                                address:
                                                    widget.teacherModel.address,
                                                phone:
                                                    widget.teacherModel.phone,
                                                email:
                                                    widget.teacherModel.email,
                                                password: widget
                                                    .teacherModel.password,
                                                oneSignalId: widget
                                                    .teacherModel.oneSignalId,
                                                datetime: widget
                                                    .teacherModel.datetime,
                                                document: documents,
                                                isBlocked: widget
                                                    .teacherModel.isBlocked,
                                                canAddFees: widget
                                                    .teacherModel.canAddFees,
                                                canAddGallery: widget
                                                    .teacherModel.canAddGallery,
                                                canAddStudent: widget
                                                    .teacherModel.canAddStudent,
                                                canEditMeal: widget
                                                    .teacherModel.canEditMeal,
                                                canPromoteClass: widget
                                                    .teacherModel
                                                    .canPromoteClass));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: getBoldText(
                                                'Update Documents',
                                                14,
                                                Colors.white),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                            color: MyColors.blueColor,
                            child:
                                getNormalText('Add document', 15, Colors.white),
                            onPressed: () {
                              setState(() {
                                showAddDocs = true;
                              });
                            }),
                        RaisedButton(
                          color: MyColors.blueColor,
                          onPressed: () {
                            List<String?> images = [];
                            widget.teacherModel.document.forEach((element) {
                              images.add(element['doc_img']);
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrintBill(
                                          images: images,
                                        )));
                          },
                          child: getNormalText('Save Docs', 14, Colors.white),
                        ),
                      ],
                    )
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
