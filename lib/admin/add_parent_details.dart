import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/admin/add_fees.dart';
import 'package:narayandas_app/admin/add_student.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:narayandas_app/utils/helper.dart';

class AddParentDetail extends StatefulWidget {
  const AddParentDetail({Key? key}) : super(key: key);

  @override
  _AddParentDetailState createState() => _AddParentDetailState();
}

class _AddParentDetailState extends State<AddParentDetail> {
  bool isLoading = false;
  late String fatherName = '';
  late String motherName = '';
  late String address = '';
  late String mobileNumber = '';
  late int totalFees = 0;
  List<ChildModel> children = [];
  late String email = '';
  late String password = '';
  List<Map<String, dynamic>> feeBreakdown = [];
  late String feeTitle = '';
  late int amount = 0;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController t6 = TextEditingController();
  TextEditingController t7 = TextEditingController();

  TextEditingController t8 = TextEditingController();
  TextEditingController t9 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('New Admission', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getBoldText('Enter Details', 16, MyColors.blueColor),
                      TextFormField(
                        controller: t1,
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
                        controller: t2,
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
                        controller: t3,
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
                        controller: t4,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter a phone number',
                          labelText: 'Phone',
                        ),
                        keyboardType: TextInputType.phone,
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
                        controller: t5,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter total fees',
                          labelText: 'Total Fees',
                        ),
                        keyboardType: TextInputType.number,
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
                      getBoldText('Fee Breakdown', 16, MyColors.blueColor),
                      SizedBox(
                        height: 10,
                      ),
                      feeBreakdown.isEmpty
                          ? Container(
                              height: 0,
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: feeBreakdown.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          getBoldText(
                                              feeBreakdown[index]['fee_title'],
                                              15,
                                              Colors.black),
                                          getNormalText(
                                              '₹ ' +
                                                  feeBreakdown[index]['amount']
                                                      .toString(),
                                              15,
                                              Colors.black),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                              }),
                      Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: TextFormField(
                                    controller: t9,
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.edit,
                                        color: MyColors.blueColor,
                                      ),
                                      hintText: 'Fee purpose',
                                      labelText: 'Fees',
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      feeTitle = newValue!;
                                    },
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: TextFormField(
                                    controller: t8,
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.money,
                                        color: MyColors.blueColor,
                                      ),
                                      hintText: 'Enter amount',
                                      labelText: 'Amount',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter some value';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      amount = int.parse(newValue!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey2.currentState!.validate()) {
                                  _formKey2.currentState!.save();
                                  setState(() {
                                    feeBreakdown.add({
                                      'fee_title': feeTitle,
                                      'amount': amount,
                                    });
                                  });

                                  _formKey2.currentState!.reset();
                                  t8.clear();
                                  t9.clear();
                                }
                              },
                              child: getNormalText(
                                'Add Fee',
                                13,
                                Colors.blue,
                              ),
                            )
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
                        controller: t6,
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
                        controller: t7,
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
                            'Add Child',
                            15,
                            Colors.white,
                          ),
                          onPressed: () {
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
                                feeBreakdown: feeBreakdown,
                                dateTime: DateTime.now().toString(),
                                isBlocked: false,
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
