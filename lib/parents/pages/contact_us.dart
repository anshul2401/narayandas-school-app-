import 'package:flutter/material.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Contact Us', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      height: 100,
                      child: Image.asset('assets/images/school_sq.jpeg'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.pin_drop,
                    color: MyColors.blueColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  getBoldText('Our Address', 15, MyColors.blueColor),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              getNormalText(
                  'dhannad - chirakhan road, 1.5 Km from nagar palika parishad , pithampur sector-1 Dhar Dhar, Madhya Pradesh, India 454775',
                  15,
                  Colors.black),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone_android,
                    color: MyColors.blueColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  getBoldText('Mobile', 15, MyColors.blueColor),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              getNormalText('088715 88898', 15, Colors.black),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(
                    Icons.email,
                    color: MyColors.blueColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  getBoldText('Email', 15, MyColors.blueColor),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              getNormalText('anuragagal10@gmail.com', 15, Colors.black),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(
                    Icons.watch_later,
                    color: MyColors.blueColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  getBoldText('Opening Hours', 15, MyColors.blueColor),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              getNormalText('09:00 - 14:00', 15, Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
