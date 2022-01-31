import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/account_model.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/utils/strings.dart';

class AccountProvider with ChangeNotifier {
  List<AccountModel> _account = [];
  List<AccountModel> get account => _account;
  Future<void> addAccount(AccountModel accountModel) {
    return http
        .post(Uri.parse(accountUrl),
            body: json.encode({
              'remark': accountModel.remark,
              'deb_cred': accountModel.debCred,
              'amount': accountModel.amount,
              'date_time': accountModel.dateTime,
            }))
        .then((value) {
      var newAccount = AccountModel(
          id: json.decode(value.body)['name'],
          remark: accountModel.remark,
          dateTime: accountModel.dateTime,
          debCred: accountModel.debCred,
          amount: accountModel.amount);
      _account.insert(0, newAccount);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetAccount() async {
    try {
      final resopnse = await http.get(Uri.parse(accountUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<AccountModel> loadedAccount = [];
      data.forEach((key, value) {
        loadedAccount.add(AccountModel(
            id: key,
            amount: value['amount'],
            remark: value['remark'],
            dateTime: value['date_time'],
            debCred: value['deb_cred']));
      });
      _account = loadedAccount;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Future<void> updateFees(String id, FeesModel feesModel) async {
  //   final feesIndex = _fees.indexWhere((c) => c.id == id);
  //   if (feesIndex >= 0) {
  //     try {
  //       var url = baseUrl + 'fees/$id.json';
  //       await http.patch(Uri.parse(url),
  //           body: json.encode({
  //             'parent_id': feesModel.parentId,
  //             'remark': feesModel.remark,
  //             'amount': feesModel.amount,
  //             'date_time': feesModel.dateTime,
  //             'mode_of_payment': feesModel.modeOfPayment,
  //             'is_approved_by_admin': feesModel.isApprovedByAdmin,
  //           }));
  //       _fees[feesIndex] = feesModel;
  //       notifyListeners();
  //     } catch (e) {
  //       throw (e);
  //     }
  //   } else {
  //     print('...');
  //   }
  // }
}
