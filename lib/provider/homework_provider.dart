import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/homework_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class HomeworkProvider with ChangeNotifier {
  List<HomeworkModel> _homework = [];
  List<HomeworkModel> get homework => _homework;
  Future<void> addHomework(HomeworkModel homeworkModel) {
    return http
        .post(Uri.parse(homeworkUrl),
            body: json.encode({
              'teacher_id': homeworkModel.teacherId,
              'standard': homeworkModel.standard,
              'homework_text': homeworkModel.homeworktext,
              'img_url': homeworkModel.imgUrl,
              'date_time': homeworkModel.dateTime,
              'remark': homeworkModel.remark,
              'subject': homeworkModel.subject,
            }))
        .then((value) {
      var newHomework = HomeworkModel(
          id: json.decode(value.body)['name'],
          homeworktext: homeworkModel.homeworktext,
          imgUrl: homeworkModel.imgUrl,
          standard: homeworkModel.standard,
          teacherId: homeworkModel.teacherId,
          dateTime: homeworkModel.dateTime,
          remark: homeworkModel.remark,
          subject: homeworkModel.subject);
      _homework.insert(0, newHomework);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetAndSetHomework() async {
    try {
      final resopnse = await http.get(Uri.parse(homeworkUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<HomeworkModel> loadedHomework = [];
      data.forEach((key, value) {
        loadedHomework.add(HomeworkModel(
          id: key,
          homeworktext: value['homework_text'],
          imgUrl: value['img_url'],
          teacherId: value['teacher_id'],
          subject: value['subject'],
          standard: value['standard'],
          dateTime: value['date_time'],
          remark: value['remark'],
        ));
      });
      _homework = loadedHomework;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateHomework(String id, HomeworkModel homeworkModel) async {
    final index = _homework.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'homework/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'subject': homeworkModel.subject,
              'teacher_id': homeworkModel.teacherId,
              'standard': homeworkModel.standard,
              'homework_text': homeworkModel.homeworktext,
              'img_url': homeworkModel.imgUrl,
              'date_time': homeworkModel.dateTime,
            }));
        _homework[index] = homeworkModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
