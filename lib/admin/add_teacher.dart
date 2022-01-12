import 'package:flutter/material.dart';
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
  late String name;
  late String email;
  late String password;
  late String address;
  late String mobileNumber;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: getAppBar('Add Teacher', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getBoldText('Enter Details', 16, MyColors.blueColor),
                TextFormField(
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
                      var teacherProvider =
                          Provider.of<TeacherProvider>(context, listen: false);

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
                          document: [],
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
}
