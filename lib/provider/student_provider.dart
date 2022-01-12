import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/utils/strings.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;
  Future<void> addStudent(StudentModel studentModel) {
    return http
        .post(Uri.parse(studentUrl),
            body: json.encode({
              'name': studentModel.name,
              'standard': studentModel.standard,
              'parent_id': studentModel.parentId,
              'gender': studentModel.gender,
              'blood_group': studentModel.bloodGroup,
              'dob': studentModel.dob,
              'documents': studentModel.documents
            }))
        .then((value) {
      // var newStudent = StudentModel(id: , parentId: parentId, name: name, standard: standard, documents: documents, dob: dob, bloodGroup: bloodGroup, gender: gender)
    });
  }

  Future<void> fetchAndSetStudents() async {
    try {
      final resopnse = await http.get(Uri.parse(studentUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<StudentModel> loadedStudent = [];
      data.forEach((key, value) {
        loadedStudent.add(StudentModel(
          id: key,
          bloodGroup: value['blood_group'],
          dob: value['dob'],
          documents: [],
          gender: value['gender'],
          name: value['name'],
          parentId: value['parent_id'],
          standard: value['standard'],
        ));
      });
      _students = loadedStudent;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
