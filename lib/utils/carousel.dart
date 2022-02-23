import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:narayandas_app/model/notice_model.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';

class CarouselWithIndicatorDemo extends StatefulWidget {
  late List<NoticeModel> notice;
  CarouselWithIndicatorDemo({Key? key, required this.notice}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.notice
        .map((item) => Card(
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  getNormalText(formatDateTime(item.datetime),
                                      14, Colors.black)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: getBoldTextCenter(
                                        item.title, 16, MyColors.blueColor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: getItalicText(
                                        item.content, 15, Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 500,
                        )
                      ],
                    )),
              ),
            ))
        .toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlayInterval: Duration(seconds: 4),
              viewportFraction: 1,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.notice.map((url) {
            int index = widget.notice.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? MyColors.blueColor.withOpacity(0.9)
                    : MyColors.blueColor.withOpacity(0.4),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
