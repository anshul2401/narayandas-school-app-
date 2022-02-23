import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/utils/strings.dart';

class FeesProvider with ChangeNotifier {
  List<FeesModel> _fees = [];
  List<FeesModel> get fees => _fees;
  Future<void> addFees(FeesModel feesModel) {
    return http
        .post(Uri.parse(feesUrl),
            body: json.encode({
              'parent_id': feesModel.parentId,
              'remark': feesModel.remark,
              'amount': feesModel.amount,
              'date_time': feesModel.dateTime,
              'mode_of_payment': feesModel.modeOfPayment,
              'is_approved_by_admin': feesModel.isApprovedByAdmin,
            }))
        .then((value) {
      var newFees = FeesModel(
          id: json.decode(value.body)['name'],
          parentId: feesModel.parentId,
          remark: feesModel.remark,
          modeOfPayment: feesModel.modeOfPayment,
          dateTime: feesModel.dateTime,
          isApprovedByAdmin: feesModel.isApprovedByAdmin,
          amount: feesModel.amount);
      _fees.insert(0, newFees);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetAndSetFees() async {
    try {
      final resopnse = await http.get(Uri.parse(feesUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<FeesModel> loadedFees = [];
      data.forEach((key, value) {
        loadedFees.add(FeesModel(
            id: key,
            amount: value['amount'],
            modeOfPayment: value['mode_of_payment'],
            parentId: value['parent_id'],
            remark: value['remark'],
            dateTime: value['date_time'],
            isApprovedByAdmin: value['is_approved_by_admin']));
      });
      _fees = loadedFees;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateFees(String id, FeesModel feesModel) async {
    final feesIndex = _fees.indexWhere((c) => c.id == id);
    if (feesIndex >= 0) {
      try {
        var url = baseUrl + 'fees/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'parent_id': feesModel.parentId,
              'remark': feesModel.remark,
              'amount': feesModel.amount,
              'date_time': feesModel.dateTime,
              'mode_of_payment': feesModel.modeOfPayment,
              'is_approved_by_admin': feesModel.isApprovedByAdmin,
            }));
        _fees[feesIndex] = feesModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }

  List<FeesModel> getApprovedFees() {
    return _fees.where((element) {
      return element.isApprovedByAdmin == true;
    }).toList();
  }
}
