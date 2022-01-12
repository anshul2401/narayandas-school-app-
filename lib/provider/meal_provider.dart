import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:http/http.dart' as http;
import 'package:narayandas_app/utils/strings.dart';

class MealProvider with ChangeNotifier {
  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;
  Future<void> addMeal(MealModel mealModel) {
    return http
        .post(Uri.parse(mealUrl),
            body: json.encode({
              'day': mealModel.day,
              'meal': mealModel.meal,
              'benifit': mealModel.benifit
            }))
        .then((value) {
      var newMeal = MealModel(
          id: json.decode(value.body)['name'],
          day: mealModel.day,
          benifit: mealModel.benifit,
          meal: mealModel.meal);
      _meals.insert(0, newMeal);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetAndSetMeal() async {
    try {
      final resopnse = await http.get(Uri.parse(mealUrl));
      final data = json.decode(resopnse.body) as Map<String, dynamic>;
      final List<MealModel> loadedMeal = [];
      data.forEach((key, value) {
        loadedMeal.add(MealModel(
            id: key,
            benifit: value['benifit'],
            day: value['day'],
            meal: value['meal']));
      });
      _meals = loadedMeal;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateMeal(String id, MealModel mealModel) async {
    final index = _meals.indexWhere((c) => c.id == id);
    if (index >= 0) {
      try {
        var url = baseUrl + 'meals/$id.json';
        await http.patch(Uri.parse(url),
            body: json.encode({
              'day': mealModel.day,
              'meal': mealModel.meal,
              'benifit': mealModel.benifit
            }));
        _meals[index] = mealModel;
        notifyListeners();
      } catch (e) {
        throw (e);
      }
    } else {
      print('...');
    }
  }
}
