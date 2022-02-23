import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/model/notice_model.dart';
import 'package:narayandas_app/model/story_model.dart';
import 'package:narayandas_app/utils/strings.dart';

class StoryProvider with ChangeNotifier {
  List<StoryModel> _story = [];
  List<StoryModel> get story => _story;
  Future<void> addStory(StoryModel storyModel) {
    return http
        .post(Uri.parse(storyUrl),
            body: json.encode({
              'title': storyModel.title,
              'img_url': storyModel.imgUrl,
              'date_time': storyModel.datetime
            }))
        .then((value) {
      var newStroy = StoryModel(
        id: json.decode(value.body)['name'],
        imgUrl: storyModel.imgUrl,
        title: storyModel.title,
        datetime: storyModel.datetime,
      );
      _story.insert(0, newStroy);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetStroy() async {
    try {
      final resopnse = await http.get(Uri.parse(storyUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<StoryModel> loadedStory = [];
      data.forEach((key, value) {
        loadedStory.add(StoryModel(
            id: key,
            datetime: value['date_time'],
            title: value['title'],
            imgUrl: value['img_url']));
      });
      _story = loadedStory;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteStroy(String id) async {
    final index = _story.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'story/$id.json';
        await http.delete(
          Uri.parse(url),
        );
        _story.removeAt(index);
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
