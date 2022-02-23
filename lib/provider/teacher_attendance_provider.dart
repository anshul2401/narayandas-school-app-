import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/teacher_attendance_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class TeacherAttendanceProvider with ChangeNotifier {
  List<TeacherAttendanceModel> _teacherAttendance = [];
  List<TeacherAttendanceModel> get teacherAttendance => _teacherAttendance;

  Future<void> addTeacherAttendance(
      TeacherAttendanceModel teacherAttendanceModel) {
    return http
        .post(Uri.parse(teacherAttendanceUrl),
            body: json.encode({
              'date_time': teacherAttendanceModel.dateTime,
              'present_teachers': teacherAttendanceModel.presentTeachers,
              'absent_teachers': teacherAttendanceModel.absentTeachers,
            }))
        .then((value) {
      var newTeacherAttendance = TeacherAttendanceModel(
          id: json.decode(value.body)['name'],
          dateTime: teacherAttendanceModel.dateTime,
          absentTeachers: teacherAttendanceModel.absentTeachers,
          presentTeachers: teacherAttendanceModel.presentTeachers);
      _teacherAttendance.insert(0, newTeacherAttendance);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetAndSetTeacherAttendance() async {
    try {
      final resopnse = await http.get(Uri.parse(teacherAttendanceUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<TeacherAttendanceModel> loadedTeacherAttendance = [];
      List<Map<String, String>> docs(List<dynamic> li) {
        List<Map<String, String>> ls = [];
        li.forEach((element) {
          ls.add(
            {
              'name': element['name'],
              'teacher_id': element['teacher_id'],
            },
          );
        });
        return ls;
      }

      data.forEach((key, value) {
        loadedTeacherAttendance.add(TeacherAttendanceModel(
          id: key,
          absentTeachers: value['absent_teachers'] == null
              ? []
              : docs(value['absent_teachers']),
          presentTeachers: value['present_teachers'] == null
              ? []
              : docs(value['present_teachers']),
          dateTime: value['date_time'],
        ));
      });
      _teacherAttendance = loadedTeacherAttendance;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
