import 'package:flutter/material.dart';
import 'package:narayandas_app/utils/helper.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('About Us', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/images/school_wide.jpeg',
                  )),
              SizedBox(
                height: 10,
              ),
              getNormalText(
                  'best school in pithampur area with mordern infrastructure and well trained teachers with bus facility.',
                  15,
                  Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
