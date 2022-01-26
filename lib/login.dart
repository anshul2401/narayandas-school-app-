import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/home_page.dart';
import 'package:narayandas_app/model/auth_model.dart';
import 'package:narayandas_app/parents/parents_home_page.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/teacher/teacher_home_page.dart';
import 'package:narayandas_app/user_auth.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/shared_pref.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool isLoading = false;
  UserAuth userAuth = UserAuth();
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Scaffold(
              body: getLoading(context),
            )
          : Scaffold(
              backgroundColor: MyColors.blueColor,
              body: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getBoldText(
                              'Welcome back! ', 25, MyColors.goldenColor),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            child: Image.asset('assets/images/logo.jpeg'),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          getItalicText('Please Login', 18, Colors.white),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Email'),
                              autocorrect: false,
                              onSaved: (newValue) {
                                email = newValue!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Password'),
                              autocorrect: false,
                              onSaved: (newValue) {
                                password = newValue!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                _formKey.currentState!.save();
                                var authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false);
                                await authProvider.fetchAndSetAuth();
                                List<AuthModel> auth =
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .auth
                                        .toList();
                                bool isCorrect = false;
                                auth.forEach((element) async {
                                  if (element.email == email &&
                                      element.password == password) {
                                    isCorrect = true;
                                    // await userAuth
                                    //     .setCurrentUser(element.id, context)
                                    //     .then((value) {
                                    //   setState(() {
                                    //     isLoading = false;
                                    //   });
                                    // });
                                    currentUser = element;
                                    await SharedPreferenceHelper()
                                        .saveUserId(element.id);
                                    await SharedPreferenceHelper()
                                        .saveUserRole(element.role);
                                  }
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                if (!isCorrect) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'Email id or password is incorrect'),
                                  ));
                                } else {
                                  currentUser!.role == 'Teacher'
                                      ? Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TeacherHomePage()))
                                      : currentUser!.role == 'Parent'
                                          ? Navigator.of(context)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ParentHomePage()))
                                          : Navigator.of(context)
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminHomePage()));
                                }
                              }
                            },
                            color: MyColors.goldenColor,
                            child: getBoldText(
                              'Login',
                              15,
                              Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
