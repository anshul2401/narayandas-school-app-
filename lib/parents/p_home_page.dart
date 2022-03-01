import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/login.dart';
import 'package:narayandas_app/parents/const.dart';
import 'package:narayandas_app/parents/pages/about_us.dart';
import 'package:narayandas_app/parents/pages/contact_us.dart';
import 'package:narayandas_app/parents/pages/gallery.dart';
import 'package:narayandas_app/parents/story_view.dart';
import 'package:narayandas_app/parents/view_fees.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/provider/youtube_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PHomePage extends StatefulWidget {
  const PHomePage({Key? key}) : super(key: key);

  @override
  _PHomePageState createState() => _PHomePageState();
}

class _PHomePageState extends State<PHomePage> {
  YoutubePlayerController? _yc;
  @override
  void initState() {
    _yc = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          Provider.of<YoutubeProvider>(context, listen: false)
              .youtubeModel[0]
              .url)!,
      flags: const YoutubePlayerFlags(
        loop: true,
        autoPlay: true,
        isLive: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Welcome Parent', context),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.book,
                color: MyColors.blueColor,
              ),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.image,
                color: MyColors.blueColor,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Gallery()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.phone,
                color: MyColors.blueColor,
              ),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUs()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: MyColors.blueColor,
              ),
              title: const Text('Log Out'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final success = await prefs.remove('USERKEY');
                final successs = await prefs.remove('USERROLEKEY');

                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(height: 360, child: StoryHome()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getActionCard('view_meal_b.png', 'Meal Schedule', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewMeal()));
                  }),
                  getActionCard('view_homework_b.png', 'View Homework', () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectClass(
                                  isHomework: false,
                                  isViewHomework: true,
                                  isPromotion: false,
                                  isViewAttendance: false,
                                  isAddNotification: false,
                                )));
                  }),
                  getActionCard('add_fees_b.png', 'Fee History', () {
                    var parents =
                        Provider.of<ParentsProvider>(context, listen: false)
                            .parents;
                    var p = parents.firstWhere((element) {
                      return element.id == currentUser!.roleId;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewFees(parentModel: p)));
                  }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _yc!,
                ),
                builder: (context, player) {
                  return Center(child: player);
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

  getActionCard(String imgUrl, String title, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        child: Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 3.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40, child: Image.asset('assets/images/$imgUrl')),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getBoldText(title, 12, Colors.black),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
