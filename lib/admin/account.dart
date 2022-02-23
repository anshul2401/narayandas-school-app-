import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:narayandas_app/model/account_model.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/account_provider.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fees Added'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('fees successfully added'),
                Text('This will reflect here once aproved by admin'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  int amount = 0;
  String remark = '';
  bool isLoading = false;
  String? modeOfPayment;
  String? paymentType;
  List<AccountModel> account = [];
  List<AccountModel> monthlyAccount = [];
  int total = 0;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<AccountProvider>(context, listen: false)
        .fetchAndSetAccount()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    var accountProvider = Provider.of<AccountProvider>(context, listen: false);
    account.addAll(accountProvider.account);
    for (var element in account) {
      element.debCred == 'Debit'
          ? total -= element.amount
          : total += element.amount;
    }
    monthlyAccount.addAll(accountProvider.getACcountByMonth(
        selectedDate.month.toString(), selectedDate.year.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getTotal() {
      int total = 0;
      for (var element in account) {
        element.debCred == 'Debit'
            ? total -= element.amount
            : total += element.amount;
      }
      return total;
    }

    getTotalCredit() {
      int total = 0;
      for (var element in account) {
        element.debCred == 'Credit' ? total += element.amount : total += 0;
      }
      return total;
    }

    getTotalDebit() {
      int total = 0;
      for (var element in account) {
        element.debCred == 'Debit' ? total += element.amount : total += 0;
      }
      return total;
    }

    getTotalCash() {
      int total = 0;
      for (var element in account) {
        if (element.modeOfPayment == 'Cash') {
          element.debCred == 'Debit'
              ? total -= element.amount
              : total += element.amount;
        }
      }
      return total;
    }

    getTotalOnline() {
      int total = 0;
      for (var element in account) {
        if (element.modeOfPayment == 'Online') {
          element.debCred == 'Debit'
              ? total -= element.amount
              : total += element.amount;
        }
      }
      return total;
    }

    getTotalMonthly() {
      int total = 0;
      for (var element in monthlyAccount) {
        element.debCred == 'Debit'
            ? total -= element.amount
            : total += element.amount;
      }
      return total;
    }

    getTotalCreditMonthly() {
      int total = 0;
      for (var element in monthlyAccount) {
        element.debCred == 'Credit' ? total += element.amount : total += 0;
      }
      return total;
    }

    getTotalDebitMonthly() {
      int total = 0;
      for (var element in monthlyAccount) {
        element.debCred == 'Debit' ? total += element.amount : total += 0;
      }
      return total;
    }

    getTotalCashMonthly() {
      int total = 0;
      for (var element in monthlyAccount) {
        if (element.modeOfPayment == 'Cash') {
          element.debCred == 'Debit'
              ? total -= element.amount
              : total += element.amount;
        }
      }
      return total;
    }

    getTotalOnlineMonthly() {
      int total = 0;
      for (var element in monthlyAccount) {
        if (element.modeOfPayment == 'Online') {
          element.debCred == 'Debit'
              ? total -= element.amount
              : total += element.amount;
        }
      }
      return total;
    }

    var accountProvider = Provider.of<AccountProvider>(context, listen: false);
    account = (accountProvider.account);

    return Scaffold(
      appBar: getAppBar('Account', context),
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
                    children: [
                      getBoldText('Account Details', 15, MyColors.blueColor),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getBoldText(
                                'Total Amount: ₹ ${getTotal()}',
                                14,
                                Colors.black,
                              ),
                              getNormalText(
                                'Credit: ₹ ${getTotalCredit()}',
                                14,
                                Colors.green,
                              ),
                              getNormalText(
                                'Debit: ₹ ${getTotalDebit()}',
                                14,
                                Colors.red,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getNormalText(
                                'Cash: ₹ ${getTotalCash()}',
                                14,
                                Colors.black,
                              ),
                              getNormalText(
                                'Online: ₹ ${getTotalOnline()}',
                                14,
                                Colors.black,
                              ),
                            ],
                          )
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     getBoldText(
                      //       'Due Fees: ₹ ${0 - paidAmount}',
                      //       12,
                      //       Colors.red,
                      //     )
                      //   ],
                      // ),
                      Divider(),

                      getBoldText(
                          'Monthly Account Details', 15, MyColors.blueColor),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getBoldText(
                                'Total Amount: ₹ ${getTotalMonthly()}',
                                14,
                                Colors.black,
                              ),
                              getNormalText(
                                'Credit: ₹ ${getTotalCreditMonthly()}',
                                14,
                                Colors.green,
                              ),
                              getNormalText(
                                'Debit: ₹ ${getTotalDebitMonthly()}',
                                14,
                                Colors.red,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getNormalText(
                                'Cash: ₹ ${getTotalCashMonthly()}',
                                14,
                                Colors.black,
                              ),
                              getNormalText(
                                'Online: ₹ ${getTotalOnlineMonthly()}',
                                14,
                                Colors.black,
                              ),
                            ],
                          )
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     getBoldText(
                      //       'Due Fees: ₹ ${0 - paidAmount}',
                      //       12,
                      //       Colors.red,
                      //     )
                      //   ],
                      // ),
                      Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Payments', 15, MyColors.blueColor),
                          Row(
                            children: [
                              getNormalText(
                                  DateFormat('MMMM').format(selectedDate) +
                                      ', ',
                                  15,
                                  MyColors.blueColor),
                              getNormalText(selectedDate.year.toString(), 15,
                                  MyColors.blueColor),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                showMonthPicker(
                                  context: context,
                                  firstDate:
                                      DateTime(DateTime.now().year - 1, 5),
                                  lastDate:
                                      DateTime(DateTime.now().year + 1, 9),
                                  initialDate: DateTime.now(),
                                  locale: Locale("en"),
                                ).then((date) {
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                      monthlyAccount.clear();
                                      monthlyAccount.addAll(
                                          accountProvider.getACcountByMonth(
                                              selectedDate.month.toString(),
                                              selectedDate.year.toString()));
                                    });
                                  }
                                });
                              },
                              icon: Icon(Icons.calendar_today))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      monthlyAccount.isEmpty
                          ? getNormalText('No Record', 13, Colors.black)
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: monthlyAccount.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child: getBoldText(
                                                (index + 1).toString(),
                                                13,
                                                Colors.black),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: getNormalText(
                                                DateFormat('dd-MM-yy').format(
                                                    DateTime.parse(
                                                        monthlyAccount[index]
                                                            .dateTime)),
                                                13,
                                                Colors.black),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getNormalText(
                                                    monthlyAccount[index]
                                                        .remark,
                                                    13,
                                                    Colors.black),
                                                getBoldText(
                                                    '(' +
                                                        monthlyAccount[index]
                                                            .modeOfPayment +
                                                        ')',
                                                    13,
                                                    Colors.black),
                                              ],
                                            ),
                                          ),
                                          monthlyAccount[index].debCred ==
                                                  'Credit'
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: getNormalText(
                                                      '₹ ${monthlyAccount[index].amount.toString()}',
                                                      13,
                                                      Colors.green),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: getNormalText(
                                                      '₹ -${monthlyAccount[index].amount.toString()}',
                                                      13,
                                                      Colors.red),
                                                ),
                                        ],
                                      ),
                                      Divider()
                                    ],
                                  );
                                },
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Add installment', 15, MyColors.blueColor),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.text_fields,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter a remark',
                          labelText: 'Remark',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          remark = newValue!;
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.money,
                              color: MyColors.blueColor,
                            ),
                            hintText: 'Enter amount',
                            labelText: 'Total Amount',
                          ),
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                            alignment: Alignment.bottomCenter,
                            focusColor: Colors.white,
                            value: paymentType,

                            //elevation: 5,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: <String>[
                              'Debit',
                              'Credit',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: Text(
                              "Debit/Credit",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                paymentType = value!;
                              });
                            },
                          ),
                          DropdownButton<String>(
                            alignment: Alignment.bottomCenter,
                            focusColor: Colors.white,
                            value: modeOfPayment,

                            //elevation: 5,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: <String>[
                              'Online',
                              'Cash',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: Text(
                              "Mode of payment",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                modeOfPayment = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getBoldText(
                            'Add Record',
                            15,
                            Colors.white,
                          ),
                          onPressed: () {
                            var accountProvider = Provider.of<AccountProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              if (modeOfPayment != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                _formKey.currentState!.save();
                                var newAccount = AccountModel(
                                  id: DateTime.now().toString(),
                                  amount: amount,
                                  remark: remark,
                                  modeOfPayment: modeOfPayment!,
                                  debCred: paymentType!,
                                  dateTime: DateTime.now().toString(),
                                );
                                accountProvider
                                    .addAccount(newAccount)
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
                                    // _showMyDialog();
                                  });

                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => AddFees(
                                  //       parentModel:
                                  //           Provider.of<ParentsProvider>(context)
                                  //               .parents[0],
                                  //     ),
                                  //   ),
                                  // );
                                });
                              } else {
                                print('add mode of payment');
                              }
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
