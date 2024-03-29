import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/home_page.dart';
import 'package:narayandas_app/login.dart';
import 'package:narayandas_app/provider/about_provider.dart';
import 'package:narayandas_app/provider/account_provider.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/provider/fees_provider.dart';
import 'package:narayandas_app/provider/gallery_provider.dart';
import 'package:narayandas_app/provider/homework_provider.dart';
import 'package:narayandas_app/provider/meal_provider.dart';
import 'package:narayandas_app/provider/notice_provider.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/story_provider.dart';
import 'package:narayandas_app/provider/student_attendance_provider.dart';
import 'package:narayandas_app/provider/student_provider.dart';
import 'package:narayandas_app/provider/teacher_attendance_provider.dart';
import 'package:narayandas_app/provider/teacher_provider.dart';
import 'package:narayandas_app/provider/youtube_provider.dart';
import 'package:narayandas_app/splash.dart';
import 'package:narayandas_app/utils/shared_pref.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ParentsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => FeesProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TeacherProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => MealProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => StudentProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => StudentAttendanceProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TeacherAttendanceProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeworkProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => GalleryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AccountProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AboutProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => YoutubeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => NoticeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => StoryProvider(),
          ),
        ],
        child: MaterialApp(
            title: 'Narayandas International',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Splash()));
  }
}
