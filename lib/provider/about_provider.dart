import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/about_model.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:http/http.dart' as http;

class AboutProvider with ChangeNotifier {
  List<AboutModel> _about = [];
  List<AboutModel> get about => _about;
  Future<void> addAbout(AboutModel aboutModel) {
    return http
        .post(Uri.parse(aboutUrl),
            body: json.encode({'content': aboutModel.content}))
        .then((value) {
      var newAbout = AboutModel(
          id: json.decode(value.body)['name'], content: aboutModel.content);
      _about.add(newAbout);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetAbout() async {
    try {
      final resopnse = await http.get(Uri.parse(aboutUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<AboutModel> loadedAbout = [];
      data.forEach((key, value) {
        loadedAbout.add(AboutModel(id: key, content: value['content']));
      });
      _about = loadedAbout;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAbout(String id, AboutModel aboutModel) async {
    final index = _about.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'about/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'content': aboutModel.content,
            }));
        _about[index] = aboutModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
