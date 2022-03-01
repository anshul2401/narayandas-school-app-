import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/model/gallery_model.dart';
import 'package:narayandas_app/provider/gallery_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool isLoading = false;
  List<GalleryModel> images = [];
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<GalleryProvider>(context, listen: false)
        .fetchAndSetGallery()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var galleryProvider = Provider.of<GalleryProvider>(context);
    images = galleryProvider.gallery;
    return Scaffold(
      appBar: getAppBar('Gallery', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 3.9,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  // fit: BoxFit.cover,
                                  fit: BoxFit.fitWidth,
                                  imageUrl: images[index].imgUrl,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          getLoading(context),

                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            );
                          }),
                    ],
                  )),
            ),
    );
  }
}
