import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class ViewFees extends StatefulWidget {
  final ParentModel parentModel;
  const ViewFees({Key? key, required this.parentModel}) : super(key: key);

  @override
  _ViewFeesState createState() => _ViewFeesState();
}

class _ViewFeesState extends State<ViewFees> {
  final _formKey = GlobalKey<FormState>();
  int amount = 0;
  String remark = '';
  bool isLoading = false;
  String? modeOfPayment;
  List<FeesModel> feesTillNow = [];
  int paidAmount = 0;
  @override
  void initState() {
    var feesProvider = Provider.of<FeesProvider>(context, listen: false);
    for (var e in feesProvider.getApprovedFees()) {
      e.parentId == widget.parentModel.id ? feesTillNow.add(e) : null;
    }
    for (var element in feesTillNow) {
      paidAmount += element.amount;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Fees', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getBoldText(
                            'Total Fees: ₹ ${widget.parentModel.totalFee}',
                            14,
                            Colors.black,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getBoldText(
                            'Due Fees: ₹ ${widget.parentModel.totalFee - paidAmount}',
                            12,
                            Colors.red,
                          )
                        ],
                      ),
                      getBoldText('Fee Breakdown', 15, MyColors.blueColor),
                      SizedBox(
                        height: 10,
                      ),
                      widget.parentModel.feeBreakdown.isEmpty
                          ? getNormalText('No Record', 13, Colors.black)
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.parentModel.feeBreakdown.length,
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
                                        // Container(
                                        //   width: MediaQuery.of(context)
                                        //           .size
                                        //           .width *
                                        //       0.2,
                                        //   child: getNormalText(
                                        //       DateFormat('dd-MM-yy').format(
                                        //           DateTime.parse(
                                        //               feesTillNow[index]
                                        //                   .dateTime)),
                                        //       13,
                                        //       Colors.black),
                                        // ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: getNormalText(
                                              widget.parentModel
                                                      .feeBreakdown[index]
                                                  ['fee_title'],
                                              13,
                                              Colors.black),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: getNormalText(
                                              '₹ ${widget.parentModel.feeBreakdown[index]['amount'].toString()}',
                                              13,
                                              Colors.black),
                                        ),
                                      ],
                                    ),
                                    Divider()
                                  ],
                                );
                              },
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText(
                          'Previous installments', 15, MyColors.blueColor),
                      SizedBox(
                        height: 10,
                      ),
                      feesTillNow.isEmpty
                          ? getNormalText('No Record', 13, Colors.black)
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: feesTillNow.length,
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
                                                      feesTillNow[index]
                                                          .dateTime)),
                                              13,
                                              Colors.black),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: getNormalText(
                                              feesTillNow[index].remark,
                                              13,
                                              Colors.black),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: getNormalText(
                                              '₹ ${feesTillNow[index].amount.toString()}',
                                              13,
                                              Colors.green),
                                        ),
                                      ],
                                    ),
                                    Divider()
                                  ],
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
