import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/student_attendance_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/utils/strings.dart';

class StudentAttendanceProvider with ChangeNotifier {
  List<StudentAttendanceModel> _studentAttendance = [];
  List<StudentAttendanceModel> get studentAttendance => _studentAttendance;

  Future<void> addStudentAttendance(
      StudentAttendanceModel studentAttendanceModel) {
    return http
        .post(Uri.parse(studentAttendanceUrl),
            body: json.encode({
              'standard': studentAttendanceModel.standard,
              'date_time': studentAttendanceModel.dateTime,
              'present_children': studentAttendanceModel.presentChildren,
              'absent_children': studentAttendanceModel.absentChildren,
              'teacher_id': studentAttendanceModel.teacherId
            }))
        .then((value) {
      var newStudentAttendance = StudentAttendanceModel(
        id: json.decode(value.body)['name'],
        dateTime: studentAttendanceModel.dateTime,
        absentChildren: studentAttendanceModel.absentChildren,
        presentChildren: studentAttendanceModel.presentChildren,
        standard: studentAttendanceModel.standard,
        teacherId: studentAttendanceModel.teacherId,
      );
      _studentAttendance.insert(0, newStudentAttendance);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetAndSetStudentAttendance() async {
    try {
      final resopnse = await http.get(Uri.parse(studentAttendanceUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<StudentAttendanceModel> loadedStudentAttendance = [];
      data.forEach((key, value) {
        loadedStudentAttendance.add(StudentAttendanceModel(
          id: key,
          teacherId: value['teacher_id'],
          absentChildren: value['absent_children'],
          presentChildren: value['present_children'],
          dateTime: value['date_time'],
          standard: value['standard'],
        ));
      });
      _studentAttendance = loadedStudentAttendance;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
