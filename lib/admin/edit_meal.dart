import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:narayandas_app/admin/add_meal.dart';
import 'package:narayandas_app/admin/edit_meal.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/provider/meal_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class EditMeal extends StatefulWidget {
  final MealModel meal;
  const EditMeal({Key? key, required this.meal}) : super(key: key);

  @override
  _EditMealState createState() => _EditMealState();
}

class _EditMealState extends State<EditMeal> {
  final _formKey = GlobalKey<FormState>();

  String day = '';
  String meal = '';
  String benifit = '';
  List<MealModel> meals = [];
  bool isLoading = false;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  @override
  void initState() {
    var mealProvider = Provider.of<MealProvider>(context, listen: false);
    meals.addAll(mealProvider.meals);
    t1.text = widget.meal.day;
    t3.text = widget.meal.meal;
    t2.text = widget.meal.benifit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Meals', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Edit Meal', 15, MyColors.blueColor),
                      TextFormField(
                        controller: t1,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.text_fields,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter a day',
                          labelText: 'Day',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          day = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: t3,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Meal',
                          labelText: 'Meal',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          meal = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: t2,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.money,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter Benifit',
                          labelText: 'Benifits',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          benifit = newValue!;
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: StadiumBorder(),
                          color: MyColors.blueColor,
                          child: getBoldText(
                            'Update Meal',
                            15,
                            Colors.white,
                          ),
                          onPressed: () {
                            var mealProvider = Provider.of<MealProvider>(
                                context,
                                listen: false);

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              _formKey.currentState!.save();
                              var updatedMeal = MealModel(
                                  id: widget.meal.id,
                                  benifit: benifit,
                                  day: day,
                                  meal: meal);
                              mealProvider
                                  .updateMeal(widget.meal.id, updatedMeal)
                                  .catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Somethineg went wrong'),
                                ));
                              }).then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Successfully Updated'),
                                ));

                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => AddFees(
                                //       parentModel:
                                //           Provider.of<ParentsProvider>(context)
                                //               .parents[0],
                                //     ),
                                //   ),
                                // );
                              }).whenComplete(() {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => AddMeal()));
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
