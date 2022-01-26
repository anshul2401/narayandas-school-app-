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

class AddGalleryImage extends StatefulWidget {
  const AddGalleryImage({Key? key}) : super(key: key);

  @override
  _AddGalleryImageState createState() => _AddGalleryImageState();
}

class _AddGalleryImageState extends State<AddGalleryImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? file;
  UploadTask? task;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 5),
                            child: getBoldText(
                                'Add Image', 14, MyColors.blueColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: getNormalText(
                                  file == null ? '' : file!.name,
                                  12,
                                  Colors.black),
                            ),
                            file == null
                                ? Container()
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        file = null;
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                          ],
                        ),
                      ),
                      file == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      selectImageCamera();
                                    },
                                    child: getNormalText(
                                        'Camera', 14, Colors.blue)),
                                GestureDetector(
                                    onTap: () {
                                      selectImageGallery();
                                    },
                                    child: getNormalText(
                                        'Gallery', 14, Colors.blue)),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: MyColors.blueColor,
                        shape: StadiumBorder(),
                        child: getBoldText('Upload Gallery', 13, Colors.white),
                        onPressed: () {
                          file == null ? null : uploadImage();
                        },
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: images[index].imgUrl,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            );
                          }),
                    ],
                  )),
            ),
    );
  }

  Future selectImageCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      file = XFile(photo!.path);
    });
  }

  Future selectImageGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = XFile(photo!.path);
    });
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    File? newFile;

    if (file == null) return;
    newFile = File(file!.path);
    final dest = 'gallery_images/${file!.name}';
    task = FirebaseApi.uploadFile(dest, newFile);
    if (task == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final snapshot = await task!.whenComplete(() {
      setState(() {
        file = null;

        isLoading = false;
      });
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    var galleryProvider = Provider.of<GalleryProvider>(context, listen: false);
    setState(() {
      isLoading = false;
    });
    var newGallery =
        GalleryModel(id: DateTime.now().toString(), imgUrl: urlDownload);
    galleryProvider.addGallery(newGallery).catchError((error) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Somethineg went wrong'),
      ));
    }).then((value) {
      setState(() {
        // meals.add(newMeal);
        isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Homework Uploaded'),
        ));
      });
    });
  }
}
