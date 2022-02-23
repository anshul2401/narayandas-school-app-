import 'package:flutter/material.dart';
import 'package:narayandas_app/model/about_model.dart';
import 'package:narayandas_app/provider/about_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class EditAbout extends StatefulWidget {
  const EditAbout({Key? key}) : super(key: key);

  @override
  _EditAboutState createState() => _EditAboutState();
}

class _EditAboutState extends State<EditAbout> {
  var _formKey = GlobalKey<FormState>();
  late String content = '';
  late String id = '';
  TextEditingController t1 = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<AboutProvider>(context, listen: false)
          .fetchAndSetAbout()
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
    var mealProvider = Provider.of<AboutProvider>(context, listen: false);

    t1.text = mealProvider.about[0].content;
    id = mealProvider.about[0].id;
    return Scaffold(
      appBar: getAppBar('Edit About us', context),
      body: isLoading
          ? getLoading(context)
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  getBoldText('Edit about', 15, MyColors.blueColor),
                  TextFormField(
                    maxLines: 3,
                    controller: t1,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.text_fields,
                        color: MyColors.blueColor,
                      ),
                      hintText: 'Enter about us',
                      labelText: 'About us',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      content = newValue!;
                    },
                  ),
                  RaisedButton(
                      child: getNormalText('Save', 15, Colors.black),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var aboutProvider = Provider.of<AboutProvider>(
                              context,
                              listen: false);
                          setState(() {
                            isLoading = true;
                          });
                          _formKey.currentState!.save();
                          var newAbt = AboutModel(
                              id: DateTime.now().toString(), content: content);
                          aboutProvider
                              .updateAbout(
                                  id, AboutModel(id: id, content: content))
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
                              // meals.add(newMeal);
                              isLoading = false;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('About updated'),
                              ));
                              // _showMyDialog();
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
                      })
                ],
              ),
            ),
    );
  }
}
