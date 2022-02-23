import 'package:flutter/material.dart';
import 'package:narayandas_app/provider/about_provider.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    late String content = '';
    var mealProvider = Provider.of<AboutProvider>(context, listen: false);

    content = mealProvider.about[0].content;

    return Scaffold(
      appBar: getAppBar('About Us', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          'assets/images/school_wide.jpeg',
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    getNormalText(content, 15, Colors.black),
                  ],
                ),
              ),
            ),
    );
  }
}
