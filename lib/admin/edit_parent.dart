import 'package:flutter/material.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class EditParent extends StatefulWidget {
  final ParentModel parentModel;
  const EditParent({Key? key, required this.parentModel}) : super(key: key);

  @override
  _EditParentState createState() => _EditParentState();
}

class _EditParentState extends State<EditParent> {
  late String fatherName;
  late String motherName;
  late String email;
  late String password;
  late String address;
  late String mobileNumber;
  late int totalFee;
  List<Map<String, dynamic>> feeBreakdown = [];
  late String feeTitle = '';
  late int amount = 0;
  final TextEditingController t1 = TextEditingController();
  final TextEditingController t2 = TextEditingController();
  final TextEditingController t3 = TextEditingController();
  final TextEditingController t4 = TextEditingController();

  final TextEditingController t5 = TextEditingController();
  final TextEditingController t6 = TextEditingController();
  TextEditingController t7 = TextEditingController();

  TextEditingController t8 = TextEditingController();
  TextEditingController t9 = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    t1.text = widget.parentModel.fatherName;
    t2.text = widget.parentModel.email;
    t3.text = widget.parentModel.password;
    t4.text = widget.parentModel.address;
    t5.text = widget.parentModel.phoneNumber;
    t6.text = widget.parentModel.motherName;
    t7.text = widget.parentModel.totalFee.toString();
    feeBreakdown.addAll(widget.parentModel.feeBreakdown);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Edit Parent', context),
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
                          hintText: 'Enter father name',
                          labelText: 'Father Name',
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
                        controller: t6,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter mother name',
                          labelText: 'Mother name',
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
                                      labelText: 'Fees purpose',
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
                      TextFormField(
                        controller: t7,
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
                          totalFee = int.parse(newValue!);
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
                            var parentProvider = Provider.of<ParentsProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey.currentState!.save();
                              var newParent = ParentModel(
                                id: widget.parentModel.id,
                                email: email,
                                password: password,
                                fatherName: fatherName,
                                address: address,
                                phoneNumber: mobileNumber,
                                oneSignalId: widget.parentModel.oneSignalId,
                                children: widget.parentModel.children,
                                dateTime: DateTime.now().toString(),
                                fees: widget.parentModel.fees,
                                feeBreakdown: feeBreakdown,
                                totalFee: totalFee,
                                motherName: motherName,
                                isBlocked: false,
                              );
                              parentProvider
                                  .updateParent(
                                      widget.parentModel.id, newParent)
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

                                // Navigator.of(context).pop();
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
