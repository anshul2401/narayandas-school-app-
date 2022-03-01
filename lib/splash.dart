// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/home_page.dart';
import 'package:narayandas_app/login.dart';
import 'package:narayandas_app/model/auth_model.dart';
import 'package:narayandas_app/parents/parents_home_page.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/teacher/teacher_home_page.dart';
import 'package:narayandas_app/utils/shared_pref.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? userId;
  String? role;

  callApi() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchAndSetAuth().onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something Went Wrong'),
      ));
    });
    List<AuthModel> auth =
        Provider.of<AuthProvider>(context, listen: false).auth.toList();
    userId = (await SharedPreferenceHelper().getUserId()) ?? " ";
    print(userId);
    role = (await SharedPreferenceHelper().getUserRole()) ?? " ";
    bool isCorrect = false;
    setState(() {});
    auth.forEach((element) async {
      if (element.id == userId && element.role == role) {
        isCorrect = true;

        currentUser = element;
        await _initPlatformState(element);

        await SharedPreferenceHelper().saveUserId(element.id);
        await SharedPreferenceHelper().saveUserRole(element.role);
      }
    });
    if (!isCorrect) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    } else {
      currentUser!.role == 'Teacher'
          ? Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TeacherHomePage()))
          : currentUser!.role == 'Parent'
              ? Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ParentHomePage()))
              : currentUser!.role == 'Admin'
                  ? Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AdminHomePage()))
                  : Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Login()));
    }
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
  void initState() {
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          child: Image.asset('assets/images/logo.jpeg'),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
