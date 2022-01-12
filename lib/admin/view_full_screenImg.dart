// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imgUrl;
  const FullScreenImage({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Center(
            child: Image.network(
          imgUrl,
          fit: BoxFit.fitWidth,
        )),
      ),
    );
  }
}
