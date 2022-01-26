import 'package:flutter/material.dart';
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
  @override
  void initState() {
    t1.text = widget.teacherModel.name;
    t2.text = widget.teacherModel.email;
    t3.text = widget.teacherModel.password;
    t4.text = widget.teacherModel.address;
    t5.text = widget.teacherModel.phone;
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
                                isBlocked: false,
                              );
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
