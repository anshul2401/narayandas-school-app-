import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/chat/database.dart';
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
              'is_blocked': teacherModel.isBlocked,
              'can_edit_meal': teacherModel.canEditMeal,
              'can_add_fees': teacherModel.canAddFees,
              'can_add_student': teacherModel.canAddStudent,
              'can_add_gallery': teacherModel.canAddGallery,
              'can_promote_class': teacherModel.canPromoteClass,
            }))
        .then((value) {
      http
          .post(
        Uri.parse(authUrl),
        body: json.encode({
          'email': teacherModel.email,
          'password': teacherModel.password,
          'name': teacherModel.name,
          'one_signal_id': teacherModel.oneSignalId,
          'role': 'Teacher',
          'is_blocked': false,
          'role_id': json.decode(value.body)['name'],
        }),
      )
          .catchError((error) {
        print(error);
        throw error;
      });
      // Map<String, dynamic> userInfoMap = {
      //   "email": teacherModel.email,
      //   "username": teacherModel.email.replaceAll("@gmail.com", ""),
      //   "name": teacherModel.name,
      //   "role": 'Teacher',
      //   "imgUrl":
      //       'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/1024px-Circle-icons-profile.svg.png'
      // };
      Map<String, dynamic> userInfoMap = {
        'idUser': json.decode(value.body)['name'],
        'name': teacherModel.name,
        'role': 'Teacher',
        'urlAvatar':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/1024px-Circle-icons-profile.svg.png',
        'lastMessageTime': DateTime.now(),
      };
      DatabaseMethods()
          .addUserInfoToDB(json.decode(value.body)['name'], userInfoMap);

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
        isBlocked: teacherModel.isBlocked,
        canAddFees: teacherModel.canAddFees,
        canAddGallery: teacherModel.canAddGallery,
        canAddStudent: teacherModel.canAddStudent,
        canEditMeal: teacherModel.canEditMeal,
        canPromoteClass: teacherModel.canPromoteClass,
      );
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
      List<Map<String, String>> docs(List<dynamic> li) {
        List<Map<String, String>> ls = [];
        li.forEach((element) {
          ls.add(
            {
              'doc_name': element['doc_name'],
              'doc_img': element['doc_img'],
            },
          );
        });
        return ls;
      }

      data.forEach((key, value) {
        loadedTeacher.add(TeacherModel(
            id: key,
            name: value['name'],
            address: value['address'],
            password: value['password'],
            email: value['email'],
            datetime: value['date_time'],
            document:
                value['documents'] == null ? [] : docs(value['documents']),
            phone: value['phone'],
            isBlocked: value['is_blocked'],
            oneSignalId: value['one_signal_id'],
            canAddFees: value['can_add_fees'],
            canAddGallery: value['can_add_gallery'],
            canAddStudent: value['can_add_student'],
            canEditMeal: value['can_edit_meal'],
            canPromoteClass: value['can_promote_class']));
      });
      _teacher = loadedTeacher;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTeacher(String id, TeacherModel teacherModel) async {
    final index = _teacher.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'teachers/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'name': teacherModel.name,
              'address': teacherModel.address,
              'phone': teacherModel.phone,
              'email': teacherModel.email,
              'password': teacherModel.password,
              'document': teacherModel.document,
              'date_time': teacherModel.datetime,
              'one_signal_id': teacherModel.oneSignalId,
              'is_blocked': teacherModel.isBlocked,
              'can_edit_meal': teacherModel.canEditMeal,
              'can_add_fees': teacherModel.canAddFees,
              'can_add_student': teacherModel.canAddStudent,
              'can_add_gallery': teacherModel.canAddGallery,
              'can_promote_class': teacherModel.canPromoteClass,
            }));
        _teacher[index] = teacherModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
