import 'package:flutter/material.dart';

import 'package:narayandas_app/model/meal_model.dart';

import 'package:narayandas_app/provider/meal_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class ViewMeal extends StatefulWidget {
  const ViewMeal({Key? key}) : super(key: key);

  @override
  _ViewMealState createState() => _ViewMealState();
}

class _ViewMealState extends State<ViewMeal> {
  List<MealModel> meals = [];
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<MealProvider>(context, listen: false)
          .fetAndSetMeal()
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mealProvider = Provider.of<MealProvider>(context, listen: false);
    meals.addAll(mealProvider.meals);

    return Scaffold(
      appBar: getAppBar('Meals', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getBoldText(
                                meals[index].day, 15, MyColors.blueColor),
                            getNormalText(meals[index].meal, 13, Colors.black),
                            SizedBox(
                              height: 10,
                            ),
                            getBoldText('Benifits: ', 13, Colors.black),
                            getNormalText(
                                meals[index].benifit, 13, Colors.black),
                            Divider()
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
