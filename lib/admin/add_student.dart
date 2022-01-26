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
import 'package:narayandas_app/utils/helper.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool isLoading = false;
  late String fatherName = '';
  late String motherName = '';
  late String address = '';
  late String mobileNumber = '';
  late int totalFees = 0;
  List<ChildModel> children = [];
  late String email = '';
  late String password = '';
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
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStatee) {
            return AlertDialog(
              title: Text('Add Student Details'),
              content: Container(
                // height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(
                          () {
                            studentName = value;
                          },
                        );
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          dob = value;
                        });
                      },
                      keyboardType: TextInputType.datetime,
                      controller: _textFieldController2,
                      decoration: InputDecoration(hintText: "Dob"),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          bloodGroup = value;
                        });
                      },
                      keyboardType: TextInputType.text,
                      controller: _textFieldController3,
                      decoration: InputDecoration(
                        hintText: "Blood Group",
                      ),
                    ),
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       standard = value;
                    //     });
                    //   },
                    //   keyboardType: TextInputType.number,
                    //   controller: _textFieldController4,
                    //   decoration: InputDecoration(
                    //     hintText: "Standard",
                    //   ),
                    // ),
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       gender = value;
                    //     });
                    //   },
                    //   keyboardType: TextInputType.text,
                    //   controller: _textFieldController7,
                    //   decoration: InputDecoration(
                    //     hintText: "Gender",
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          alignment: Alignment.bottomCenter,
                          focusColor: Colors.white,
                          value: standard,

                          //elevation: 5,
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: standardList.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ).toList(),
                          hint: Text(
                            "Class",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String? value) {
                            setState(
                              () {
                                standard = value!;
                              },
                            );
                            setStatee(
                              () {
                                standard = value!;
                              },
                            );
                          },
                        ),
                        DropdownButton<String>(
                          alignment: Alignment.bottomCenter,
                          focusColor: Colors.white,
                          value: gender,

                          //elevation: 5,
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: ['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Gender",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                            setStatee(() {
                              gender = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  color: MyColors.blueColor,
                  textColor: Colors.white,
                  child: Text('Add'),
                  onPressed: () {
                    print(standard);
                    setState(
                      () {
                        children.add(ChildModel(
                          name: studentName,
                          standard: standard!,
                          documents: [],
                          dob: dob,
                          bloodGroup: bloodGroup,
                          gender: gender!,
                        ));
                        _textFieldController.clear();
                        _textFieldController2.clear();
                        _textFieldController3.clear();
                        _textFieldController4.clear();
                        _textFieldController7.clear();
                        documents = [];
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _displayTextInputDialogDocument(
      BuildContext context, String name) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Document'),
            content: Container(
              // height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        docName = value;
                      });
                    },
                    controller: _textFieldController5,
                    decoration: InputDecoration(hintText: "Document name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: getNormalText(
                              file == null ? '' : file!.name, 12, Colors.black),
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
                                child:
                                    getNormalText('Camera', 14, Colors.blue)),
                            GestureDetector(
                                onTap: () {
                                  selectImageGallery();
                                },
                                child:
                                    getNormalText('Gallery', 14, Colors.blue)),
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
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: MyColors.blueColor,
                textColor: Colors.white,
                child: Text('Add'),
                onPressed: () {
                  uploadImage(name);
                  Navigator.pop(context);
                  // setState(() {
                  //   _textFieldController6.clear();

                  // });
                },
              ),
            ],
          );
        });
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

  Future uploadImage(String name) async {
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
      ChildModel child = children.firstWhere((element) {
        return element.name == name;
      });
      var docs = child.documents;
      docs.add(document);

      children[children.indexWhere((element) => element.name == name)] =
          ChildModel(
              name: child.name,
              standard: child.standard,
              documents: docs,
              bloodGroup: child.bloodGroup,
              dob: child.dob,
              gender: child.gender);

      _textFieldController5.clear();
    });
    // saveForm(urlDownload);
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formkey2 = GlobalKey<FormState>();
    return Scaffold(
      appBar: getAppBar('New Admission', context),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getBoldText(
                        'Add child details',
                        16,
                        MyColors.blueColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: children.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getBoldText((index + 1).toString(), 14,
                                          Colors.black),
                                      getNormalText(children[index].name, 14,
                                          Colors.black),
                                      getNormalText(children[index].standard,
                                          14, Colors.black),
                                    ],
                                  ),
                                  children[index].documents.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              children[index].documents.length,
                                          itemBuilder: (context, indexx) {
                                            return Row(
                                              children: [
                                                getNormalText(
                                                    children[index]
                                                            .documents
                                                            .isEmpty
                                                        ? ""
                                                        : children[index]
                                                                    .documents[
                                                                indexx]
                                                            ['doc_name']!,
                                                    15,
                                                    Colors.black),
                                              ],
                                            );
                                          })
                                      : Container(
                                          height: 0,
                                        ),
                                  Form(
                                    key: _formkey2,
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
                                          decoration: InputDecoration(
                                              hintText: "Document name"),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: getNormalText(
                                                    file == null
                                                        ? ''
                                                        : file!.name,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        selectImageCamera();
                                                      },
                                                      child: getNormalText(
                                                          'Camera',
                                                          14,
                                                          Colors.blue)),
                                                  GestureDetector(
                                                      onTap: () {
                                                        selectImageGallery();
                                                      },
                                                      child: getNormalText(
                                                          'Gallery',
                                                          14,
                                                          Colors.blue)),
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
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _formkey2.currentState!.save();
                                      uploadImage(children[index].name);
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
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            documents.clear();
                          });
                          _displayTextInputDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getNormalText('Add Student', 14, Colors.lightBlue)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      getBoldText('Enter Details', 16, MyColors.blueColor),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.male,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter father\'s name',
                          labelText: 'Father\'s Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          fatherName = newValue!;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.female,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter mother\'s name',
                          labelText: 'Mother\'s Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          motherName = newValue!;
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
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter total fees',
                          labelText: 'Total Fees',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          totalFees = int.parse(newValue!);
                        },
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
                          hintText: 'Enter Email',
                          labelText: 'Email',
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
                          hintText: 'Enter password',
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

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey.currentState!.save();
                              var newParent = ParentModel(
                                  id: DateTime.now().toString(),
                                  email: email,
                                  password: password,
                                  fatherName: fatherName,
                                  motherName: motherName,
                                  address: address,
                                  phoneNumber: mobileNumber,
                                  oneSignalId: '',
                                  totalFee: totalFees,
                                  children: children,
                                  fees: [],
                                  dateTime: DateTime.now().toString(),
                                  isBlocked: false);
                              parentProvider
                                  .addParent(newParent)
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
