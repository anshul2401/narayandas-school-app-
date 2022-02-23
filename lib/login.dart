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
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // setState(() {
    //   isLoading = true;
    // });
    // Future.delayed(Duration.zero).then((value) {
    //   _initPlatformState();
    // });
    // if (mounted) {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    super.initState();
  }

  Future<void> _initPlatformState(AuthModel element) async {
    // var oneSignalProvider = Provider.of<OneSignalIds>(context, listen: false);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setAppId(ONE_SIGNAL_ID);

    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var playerId = deviceState.userId!;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.updateAuth(
        element.id,
        AuthModel(
            id: element.id,
            email: element.email,
            name: element.name,
            password: element.password,
            isBlocked: element.isBlocked,
            role: element.role,
            oneSignalId: playerId,
            roleId: element.roleId));

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    // OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    //   print("Accepted permission: $accepted");
    // });
    // await oneSignalProvider.fetchAndSetOneSignalId();
    // await OneSignal.shared.getDeviceState().then((value) {
    //   oneSignalProvider.oneSingalId.contains(value!.userId)
    //       ? null
    //       : oneSignalProvider.addOneSignalId(value.userId);
    // });
  }

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

                                    // await OneSignal.shared
                                    //     .getDeviceState()
                                    //     .then((value) async {
                                    //   var authProvider =
                                    //       Provider.of<AuthProvider>(context,
                                    //           listen: false);
                                    //   await authProvider.updateAuth(
                                    //       element.id,
                                    //       AuthModel(
                                    //           id: element.id,
                                    //           email: element.email,
                                    //           name: element.name,
                                    //           password: element.password,
                                    //           isBlocked: element.isBlocked,
                                    //           role: element.role,
                                    //           oneSignalId: value!.userId ?? ' ',
                                    //           roleId: element.roleId));
                                    // });
                                    currentUser = element;
                                    await _initPlatformState(element);

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
