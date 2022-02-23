import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/notice_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class NoticeProvider with ChangeNotifier {
  List<NoticeModel> _notice = [];
  List<NoticeModel> get notice => _notice;
  Future<void> addNotice(NoticeModel noticeModel) {
    return http
        .post(Uri.parse(noticeUrl),
            body: json.encode({
              'title': noticeModel.title,
              'content': noticeModel.content,
              'date_time': noticeModel.datetime
            }))
        .then((value) {
      var newNotice = NoticeModel(
        id: json.decode(value.body)['name'],
        content: noticeModel.content,
        title: noticeModel.title,
        datetime: noticeModel.datetime,
      );
      _notice.insert(0, newNotice);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetNotice() async {
    try {
      final resopnse = await http.get(Uri.parse(noticeUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<NoticeModel> loadedNotice = [];
      data.forEach((key, value) {
        loadedNotice.add(NoticeModel(
            id: key,
            datetime: value['date_time'],
            title: value['title'],
            content: value['content']));
      });
      _notice = loadedNotice;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateNotice(String id, NoticeModel noticeModel) async {
    final index = _notice.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'notice/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': noticeModel.title,
              'content': noticeModel.content,
              'date_time': noticeModel.datetime
            }));
        _notice[index] = noticeModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteNotice(String id) async {
    final index = _notice.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'notice/$id.json';
        await http.delete(
          Uri.parse(url),
        );
        _notice.removeAt(index);
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
