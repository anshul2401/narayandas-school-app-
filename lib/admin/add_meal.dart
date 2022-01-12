import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:narayandas_app/admin/edit_meal.dart';
import 'package:narayandas_app/model/fees_model.dart';
import 'package:narayandas_app/model/meal_model.dart';
import 'package:narayandas_app/model/parent_model.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/provider/meal_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meal Added'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Meal Successfully added'),
                // Text('This will reflect here once aproved by admin'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                t1.clear();
                t2.clear();
                t3.clear();
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mealProvider = Provider.of<MealProvider>(context, listen: true);

    meals.addAll(mealProvider.meals);
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
                      ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getBoldText(
                                      meals[index].day, 15, MyColors.blueColor),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                                builder: (context) => EditMeal(
                                                      meal: meals[index],
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              getNormalText(
                                  meals[index].meal, 13, Colors.black),
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
                      getBoldText('Add Meal', 15, MyColors.blueColor),
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
                            'Add Meal',
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
                              var newMeal = MealModel(
                                  id: DateTime.now().toString(),
                                  benifit: benifit,
                                  day: day,
                                  meal: meal);
                              mealProvider.addMeal(newMeal).catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Somethineg went wrong'),
                                ));
                              }).then((value) {
                                setState(() {
                                  meals.add(newMeal);
                                  isLoading = false;
                                  _showMyDialog();
                                });

                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => AddFees(
                                //       parentModel:
                                //           Provider.of<ParentsProvider>(context)
                                //               .parents[0],
                                //     ),
                                //   ),
                                // );
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
