import 'package:flutter/material.dart';
import 'package:narayandas_app/model/auth_model.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/utils/shared_pref.dart';
import 'package:provider/provider.dart';

class UserAuth {
  // AuthModel? currentUser;
  Future<AuthModel> getCurrentUser(String id, BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).fetchAndSetAuth();
    List<AuthModel> _auth =
        Provider.of<AuthProvider>(context, listen: false).auth;
    return _auth.firstWhere((element) {
      return element.id == id;
    });
  }

  Future<void> setCurrentUser(String id, context) async {
    await Provider.of<AuthProvider>(context, listen: false).fetchAndSetAuth();
    List<AuthModel> _auth =
        Provider.of<AuthProvider>(context, listen: false).auth;
    AuthModel currentUser = _auth.firstWhere((element) {
      return element.id == id;
    });

    await SharedPreferenceHelper().saveUserId(id);
  }
}
