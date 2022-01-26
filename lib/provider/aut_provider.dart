import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/auth_model.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:http/http.dart' as http;
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
              'is_blocked': authModel.isBlocked,
              'role': authModel.role,
              'role_id': authModel.roleId,
            }))
        .then((value) {
      var newAuth = AuthModel(
        id: json.decode(value.body)['name'],
        email: authModel.email,
        isBlocked: authModel.isBlocked,
        password: authModel.password,
        role: authModel.role,
        roleId: authModel.roleId,
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
}
