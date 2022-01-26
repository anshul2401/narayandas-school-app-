import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/gallery_model.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/utils/strings.dart';

class GalleryProvider with ChangeNotifier {
  List<GalleryModel> _gallery = [];
  List<GalleryModel> get gallery => _gallery;
  Future<void> addGallery(GalleryModel galleryModel) {
    return http
        .post(Uri.parse(galleryUrl),
            body: json.encode({'imgUrl': galleryModel.imgUrl}))
        .then((value) {
      var newGallery = GalleryModel(
          id: json.decode(value.body)['name'], imgUrl: galleryModel.imgUrl);
      _gallery.insert(0, newGallery);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetGallery() async {
    try {
      final resopnse = await http.get(Uri.parse(galleryUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<GalleryModel> loadedGallery = [];
      data.forEach((key, value) {
        loadedGallery.add(GalleryModel(id: key, imgUrl: value['imgUrl']));
      });
      _gallery = loadedGallery;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Future<void> updateMeal(String id, MealModel mealModel) async {
  //   final index = _meals.indexWhere((c) => c.id == id);
  //   if (index >= 0) {
  //     try {
  //       var url = baseUrl + 'meals/$id.json';
  //       await http.patch(Uri.parse(url),
  //           body: json.encode({
  //             'day': mealModel.day,
  //             'meal': mealModel.meal,
  //             'benifit': mealModel.benifit
  //           }));
  //       _meals[index] = mealModel;
  //       notifyListeners();
  //     } catch (e) {
  //       throw (e);
  //     }
  //   } else {
  //     print('...');
  //   }
  // }
}
