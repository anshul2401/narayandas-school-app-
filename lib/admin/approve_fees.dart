import 'dart:math';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/theme.dart';
import 'package:provider/provider.dart';

class ApproveFees extends StatefulWidget {
  const ApproveFees({Key? key}) : super(key: key);

  @override
  _ApproveFeesState createState() => _ApproveFeesState();
}

class _ApproveFeesState extends State<ApproveFees> {
  List<FeesModel> allFees = [];

  bool isLoading = false;
  @override
  void initState() {
    // allFees.addAll(Provider.of<FeesProvider>(context, listen: false).fees);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // allFees.addAll(Provider.of<FeesProvider>(context).fees);
    // for (var element in allFees) {
    //   element.isApprovedByAdmin
    //       ? approvedFees.add(element)
    //       : pendingFees.add(element);
    // }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    allFees = [];
    // pendingFees = [];
    // approvedFees = [];

    var feesProvider = Provider.of<FeesProvider>(context);
    allFees.addAll(feesProvider.fees);
    // for (var element in allFees) {
    //   element.isApprovedByAdmin
    //       ? approvedFees.add(element)
    //       : pendingFees.add(element);
    // }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: getBoldText('Fees', 15, Colors.white),
          backgroundColor: MyColors.blueColor,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Approved',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoading ? getLoading(context) : getPendingList(),
            getApprovedList(),
          ],
        ),
      ),
    );
  }

  Widget getPendingList() {
    List<FeesModel> pendingFees = allFees.where((e) {
      return e.isApprovedByAdmin == false;
    }).toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: pendingFees.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              getBoldText(
                                  formatDateTimeWithTime(
                                      pendingFees[index].dateTime),
                                  14,
                                  MyColors.blueColor),
                              getNormalText(
                                  pendingFees[index].remark, 13, Colors.black),
                              RaisedButton(
                                  shape: StadiumBorder(),
                                  color: Colors.green,
                                  child: getNormalText(
                                      'Approve', 14, Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    var feesProvider =
                                        Provider.of<FeesProvider>(context,
                                            listen: false);
                                    feesProvider
                                        .updateFees(
                                            pendingFees[index].id,
                                            FeesModel(
                                              id: pendingFees[index].id,
                                              parentId:
                                                  pendingFees[index].parentId,
                                              remark: pendingFees[index].remark,
                                              modeOfPayment: pendingFees[index]
                                                  .modeOfPayment,
                                              dateTime:
                                                  pendingFees[index].dateTime,
                                              amount: pendingFees[index].amount,
                                              isApprovedByAdmin: true,
                                            ))
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
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Fees Approved'),
                                      ));
                                      // Navigator.of(context).pop();
                                    });
                                  })
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            getBoldText(
                              '₹ ' + pendingFees[index].amount.toString(),
                              15,
                              Colors.green,
                            ),
                            getNormalText(pendingFees[index].modeOfPayment, 12,
                                Colors.black),
                          ],
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }

  Widget getApprovedList() {
    List<FeesModel> approvedFees = allFees.where((e) {
      return e.isApprovedByAdmin == true;
    }).toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: approvedFees.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: Colors.black, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              getBoldText(
                                  formatDateTimeWithTime(
                                      approvedFees[index].dateTime),
                                  14,
                                  MyColors.blueColor),
                              getNormalText(
                                  approvedFees[index].remark, 13, Colors.black),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            getBoldText(
                              '₹ ' + approvedFees[index].amount.toString(),
                              15,
                              Colors.green,
                            ),
                            getNormalText(approvedFees[index].modeOfPayment, 12,
                                Colors.black),
                          ],
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
