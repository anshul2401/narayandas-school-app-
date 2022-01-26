import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/select_class.dart';
import 'package:narayandas_app/admin/view_meal.dart';
import 'package:narayandas_app/login.dart';
import 'package:narayandas_app/parents/const.dart';
import 'package:narayandas_app/parents/pages/about_us.dart';
import 'package:narayandas_app/parents/pages/contact_us.dart';
import 'package:narayandas_app/parents/pages/gallery.dart';
import 'package:narayandas_app/parents/view_fees.dart';
import 'package:narayandas_app/provider/parents_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:narayandas_app/utils/strings.dart';
import 'package:provider/provider.dart';
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
      initialVideoId:
          YoutubePlayer.convertUrlToId('https://youtu.be/cLnCcacIDW0')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        isLive: true,
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
              onTap: () {
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
          child: Column(
            children: [
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
              getActionCard('view_meal_b.png', 'Meal Schedule', () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewMeal()));
              }),
              getActionCard('view_homework_b.png', 'View Homework', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectClass(
                              isHomework: false,
                              isViewHomework: true,
                              isPromotion: false,
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
        ),
      ),
    );
  }

  getActionCard(String imgUrl, String title, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
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
                    getBoldText(title, 15, Colors.black),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
