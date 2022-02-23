import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/about_model.dart';
import 'package:narayandas_app/model/youtube_model.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:http/http.dart' as http;

class YoutubeProvider with ChangeNotifier {
  List<YoutubeModel> _youtubeModel = [];
  List<YoutubeModel> get youtubeModel => _youtubeModel;
  Future<void> addYoutube(YoutubeModel youtubeModel) {
    return http
        .post(Uri.parse(youtubeUrl),
            body: json.encode({'url': youtubeModel.url}))
        .then((value) {
      var newYoutube = YoutubeModel(
          id: json.decode(value.body)['name'], url: youtubeModel.url);
      _youtubeModel.add(newYoutube);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetYoutube() async {
    try {
      final resopnse = await http.get(Uri.parse(youtubeUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<YoutubeModel> loadedYt = [];
      data.forEach((key, value) {
        loadedYt.add(YoutubeModel(id: key, url: value['url']));
      });
      _youtubeModel = loadedYt;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateYoutube(String id, YoutubeModel youtubeModel) async {
    final index = _youtubeModel.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'youtube/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'url': youtubeModel.url,
            }));
        _youtubeModel[index] = youtubeModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
