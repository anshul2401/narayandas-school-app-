import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:narayandas_app/utils/colors.dart';

Text getBoldText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    )),
  );
}

Text getBoldCaptialText(String text, double fontSize, Color color) {
  return Text(
    text.toUpperCase(),
    style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    )),
  );
}

Text getNormalText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.varelaRound(
      textStyle: TextStyle(
        overflow: TextOverflow.clip,
        fontSize: fontSize,
        color: color,
      ),
    ),
    softWrap: true,
  );
}

AppBar getAppBar(String title, context) {
  return AppBar(
    centerTitle: true,
    title: getBoldText(
      title,
      16,
      Colors.white,
    ),
    backgroundColor: MyColors.blueColor,
    // automaticallyImplyLeading: false,
  );
}

Widget backArrow(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15,
        ),
        border: Border.all(
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
  );
}

bool isAdmin(String val) {
  List<String> admin = [
    // '+919340133342',
    '+918888888888',
  ];
  bool isAdmin;
  admin.contains(val) ? isAdmin = true : isAdmin = false;
  return isAdmin;
}

String? convertToAgo(DateTime input, int from) {
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    if (from == 0) {
      var newFormat = DateFormat("dd MMMM yyyy");
      final newsDate1 = newFormat.format(input);
      return newsDate1;
    } else if (from == 1) {
      return '${diff.inDays} days ago';
    } else if (from == 2) {
      var newFormat = DateFormat("dd MMMM yyyy HH:mm:ss");
      final newsDate1 = newFormat.format(input);
      return newsDate1;
    }
  } else if (diff.inHours >= 1) {
    if (input.minute == 00) {
      return '${diff.inHours} hours ago';
    } else {
      if (from == 2) {
        return 'about ${diff.inHours} hours ${input.minute} minutes ago';
      } else {
        return '${diff.inHours} hours ${input.minute} minutes ago';
      }
    }
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minutes ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} seconds ago';
  } else {
    return 'just now';
  }
}

List<String> sandardList = [
  'PPlay Group',
  'Nursery',
  'LKG',
  'UKG',
  'Class 1',
  'Class 2',
  'Class 3',
  'Class 4',
  'Class 5',
  'Class 6',
  'Class 7',
  'Class 8',
  'Class 9',
  'Class 10',
  'Class 11',
  'Class 12',
];

String formatDateTimeWithTime(String datetime) {
  String a = '@';
  return DateFormat('dd-MM-yyyy ${a} kk:mm').format(DateTime.parse(datetime));
}

String formatDateTime(String datetime) {
  return DateFormat('dd-MM-yyyy').format(DateTime.parse(datetime));
}

Widget getLoading(BuildContext context) {
  return Center(
    child: Container(
      width: 50,
      child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,

          /// Required, The loading type of the widget
          colors: const [MyColors.blueColor],

          /// Optional, The color collections
          strokeWidth: 1,

          /// Optional, The stroke of the line, only applicable to widget which contains line
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          /// Optional, Background of the widget
          pathBackgroundColor: Colors.black

          /// Optional, the stroke backgroundColor
          ),
    ),
  );
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

Widget getEmptyHereMsg() {
  return Center(child: getNormalText('Nothing here!', 20, Colors.grey));
}