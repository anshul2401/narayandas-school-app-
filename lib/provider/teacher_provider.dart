import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/teacher_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class TeacherProvider with ChangeNotifier {
  List<TeacherModel> _teacher = [];
  List<TeacherModel> get teacher => _teacher;
  Future<void> addTeacher(TeacherModel teacherModel) {
    return http
        .post(Uri.parse(teacherUrl),
            body: json.encode({
              'name': teacherModel.name,
              'address': teacherModel.address,
              'phone': teacherModel.phone,
              'email': teacherModel.email,
              'password': teacherModel.password,
              'document': teacherModel.document,
              'date_time': teacherModel.datetime,
              'one_signal_id': teacherModel.oneSignalId,
              'is_blocked': teacherModel.isBlocked
            }))
        .then((value) {
      var newTeacher = TeacherModel(
          id: json.decode(value.body)['name'],
          address: teacherModel.address,
          document: teacherModel.document,
          email: teacherModel.email,
          name: teacherModel.name,
          phone: teacherModel.phone,
          password: teacherModel.password,
          oneSignalId: teacherModel.oneSignalId,
          datetime: teacherModel.datetime,
          isBlocked: teacherModel.isBlocked);
      _teacher.insert(0, newTeacher);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetAndSetTeachers() async {
    try {
      final resopnse = await http.get(Uri.parse(teacherUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<TeacherModel> loadedTeacher = [];
      data.forEach((key, value) {
        loadedTeacher.add(TeacherModel(
          id: key,
          name: value['name'],
          address: value['address'],
          password: value['password'],
          email: value['email'],
          datetime: value['date_time'],
          document: [],
          phone: value['phone'],
          isBlocked: value['is_blocked'],
          oneSignalId: value['one_signal_id'],
        ));
      });
      _teacher = loadedTeacher;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
