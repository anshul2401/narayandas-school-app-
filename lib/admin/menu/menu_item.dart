import 'package:flutter/material.dart';
import 'package:narayandas_app/admin/add_notice.dart';
import 'package:narayandas_app/admin/edit_meal.dart';
import 'package:narayandas_app/admin/menu/add_youtube_url.dart';
import 'package:narayandas_app/admin/menu/edit_about.dart';
import 'package:narayandas_app/utils/helper.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({Key? key}) : super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Edit menu', context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            getCard('Edit About us', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditAbout()));
            }),
            getCard('Edit Youtube url', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => YoutubeUrl()));
            }),
            getCard('Add Notice', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNotice()));
            })
          ],
        ),
      ),
    );
  }

  getCard(String title, VoidCallback voidCallback) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getNormalText(title, 15, Colors.black),
          GestureDetector(
            onTap: voidCallback,
            child: Icon(Icons.edit),
          )
        ],
      ),
    ));
  }
}
