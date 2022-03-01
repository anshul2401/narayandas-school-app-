import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:narayandas_app/admin/teacher_list.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class EditTeacher extends StatefulWidget {
  final TeacherModel teacherModel;
  const EditTeacher({Key? key, required this.teacherModel}) : super(key: key);

  @override
  _EditTeacherState createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  late String name;
  late String email;
  late String password;
  late String address;
  late String mobileNumber;
  final TextEditingController t1 = TextEditingController();
  final TextEditingController t2 = TextEditingController();
  final TextEditingController t3 = TextEditingController();
  final TextEditingController t4 = TextEditingController();
  final TextEditingController t5 = TextEditingController();
  bool isLoading = false;
  bool canEditMeal = false;
  bool canAddFees = false;
  bool canAddStudent = false;
  bool canAddGallery = false;
  bool canPromoteClass = false;
  bool isBlocked = false;

  @override
  void initState() {
    t1.text = widget.teacherModel.name;
    t2.text = widget.teacherModel.email;
    t3.text = widget.teacherModel.password;
    t4.text = widget.teacherModel.address;
    t5.text = widget.teacherModel.phone;
    canEditMeal = widget.teacherModel.canEditMeal;
    canAddFees = widget.teacherModel.canAddFees;
    canAddStudent = widget.teacherModel.canAddStudent;
    canAddGallery = widget.teacherModel.canAddGallery;
    canPromoteClass = widget.teacherModel.canPromoteClass;
    isBlocked = widget.teacherModel.isBlocked;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: getAppBar('Edit Teacher', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
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
                        controller: t4,
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
                        controller: t5,
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
                      getBoldText(
                        'Create Email Id and Password',
                        16,
                        MyColors.blueColor,
                      ),
                      TextFormField(
                        controller: t2,
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
                        controller: t3,
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
                      getSwitchButton((val) {
                        setState(() {
                          canEditMeal = val;
                        });
                      }, 'Edit Meal', canEditMeal),
                      getSwitchButton((val) {
                        setState(() {
                          canAddFees = val;
                        });
                      }, 'Add Fees', canAddFees),
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
                      getSwitchButton(
                        (val) {
                          setState(() {
                            isBlocked = val;
                          });
                        },
                        'Block User',
                        isBlocked,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getBoldText(
                            'Update',
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
                                  id: widget.teacherModel.id,
                                  email: email,
                                  password: password,
                                  name: name,
                                  address: address,
                                  phone: mobileNumber,
                                  oneSignalId: widget.teacherModel.oneSignalId,
                                  document: [],
                                  datetime: DateTime.now().toString(),
                                  isBlocked: isBlocked,
                                  canAddFees: canAddFees,
                                  canAddGallery: canAddGallery,
                                  canAddStudent: canAddStudent,
                                  canEditMeal: canEditMeal,
                                  canPromoteClass: canPromoteClass);
                              teacherProvider
                                  .updateTeacher(
                                      widget.teacherModel.id, newTeacher)
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
                                    content: Text('Updated Successfully'),
                                  ));
                                });

                                Navigator.of(context).pop();
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getButton(() async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder: (context, s) {
                                    return AlertDialog(
                                      title: getBoldText(
                                          'Delete User', 16, Colors.green),
                                      content: getNormalText(
                                          'Are you sure?', 13, Colors.black),
                                      actions: [
                                        RaisedButton(
                                            color: Colors.red,
                                            child: getNormalText(
                                                'Cancel', 14, Colors.white),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        RaisedButton(
                                            color: Colors.green,
                                            child: getNormalText(
                                                'Delete', 14, Colors.white),
                                            onPressed: () {
                                              var teacherProvider =
                                                  Provider.of<TeacherProvider>(
                                                      context,
                                                      listen: false);
                                              setState(() {
                                                isLoading = true;
                                              });
                                              widget.teacherModel.document
                                                  .forEach((element) async {
                                                await FirebaseStorage.instance
                                                    .refFromURL(
                                                        element['doc_img']!)
                                                    .delete();
                                              });

                                              teacherProvider
                                                  .deleteTeacher(
                                                      widget.teacherModel.id)
                                                  .then((value) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TeacherList()));
                                              });
                                            }),
                                      ],
                                    );
                                  });
                                });
                          }, 'Delete User', Colors.red),
                        ],
                      )
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
}
