import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/auth_model.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/one_signal_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class AuthProvider with ChangeNotifier {
  List<AuthModel> _auth = [];
  List<AuthModel> get auth => _auth;
  Future<void> addAuth(AuthModel authModel) {
    return http
        .post(Uri.parse(authUrl),
            body: json.encode({
              'email': authModel.email,
              'password': authModel.password,
              'name': authModel.name,
              'is_blocked': authModel.isBlocked,
              'role': authModel.role,
              'role_id': authModel.roleId,
              'one_signal_id': authModel.oneSignalId,
            }))
        .then((value) {
      var newAuth = AuthModel(
        id: json.decode(value.body)['name'],
        email: authModel.email,
        name: authModel.name,
        isBlocked: authModel.isBlocked,
        password: authModel.password,
        role: authModel.role,
        roleId: authModel.roleId,
        oneSignalId: authModel.oneSignalId,
      );
      _auth.insert(0, newAuth);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetAuth() async {
    try {
      final resopnse = await http.get(Uri.parse(authUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;

      final List<AuthModel> loadedAuth = [];
      data.forEach((key, value) {
        loadedAuth.add(AuthModel(
            id: key,
            email: value['email'],
            password: value['password'],
            isBlocked: value['is_blocked'],
            role: value['role'],
            name: value['name'],
            oneSignalId: value['one_signal_id'],
            roleId: value['role_id']));
      });
      _auth = loadedAuth;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<AuthModel> getUserAuthDetails(String id) async {
    await fetchAndSetAuth();
    return _auth.firstWhere((element) {
      return element.id == id;
    });
  }

  Future<void> updateAuth(String id, AuthModel authModel) async {
    final index = _auth.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'auth/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'email': authModel.email,
              'password': authModel.password,
              'name': authModel.name,
              'one_signal_id': authModel.oneSignalId,
              'role': authModel.role,
              'role_id': authModel.roleId,
              'is_blocked': authModel.isBlocked,
            }));
        _auth[index] = authModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }

  List<OneSignalModel> parentOneSignalModel() {
    List<OneSignalModel> oneSignalIds = [];
    _auth.forEach((element) {
      element.role == 'Parent'
          ? oneSignalIds.add(OneSignalModel(
              oneSignalId: element.oneSignalId,
              role: 'Parent',
              roleId: element.roleId))
          : null;
    });
    return oneSignalIds;
  }

  List<String> parentOneSignalIds() {
    List<String> oneSignalIds = [];
    _auth.forEach((element) {
      element.role == 'Parent' ? oneSignalIds.add(element.oneSignalId) : null;
    });
    return oneSignalIds;
  }

  List<String> teacherOneSignalIds() {
    List<String> oneSignalIds = [];
    _auth.forEach((element) {
      element.role == 'Teacher' ? oneSignalIds.add(element.oneSignalId) : null;
    });
    return oneSignalIds;
  }

  String oneSignalId(String roleId) {
    OneSignalModel o = parentOneSignalModel().firstWhere((element) {
      return element.roleId == roleId;
    });
    return o.oneSignalId;
  }

  List<OneSignalModel> teacherOneSignal() {
    List<OneSignalModel> oneSignalIds = [];
    _auth.forEach((element) {
      element.role == 'Teacher'
          ? oneSignalIds.add(
              OneSignalModel(
                oneSignalId: element.oneSignalId,
                role: 'Teacher',
                roleId: element.roleId,
              ),
            )
          : null;
    });
    return oneSignalIds;
  }
}
