import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:narayandas_app/model/notice_model.dart';
import 'package:narayandas_app/model/story_model.dart';
import 'package:narayandas_app/provider/aut_provider.dart';
import 'package:narayandas_app/provider/notice_provider.dart';
import 'package:narayandas_app/provider/story_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';

class AddStory extends StatefulWidget {
  const AddStory({Key? key}) : super(key: key);

  @override
  _AddStoryState createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String title = '';

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? file;
  UploadTask? task;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<StoryProvider>(context, listen: false)
        .fetchAndSetStroy()
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<StoryModel> story = [];
    var storyProvider = Provider.of<StoryProvider>(context);
    story = storyProvider.story;
    return Scaffold(
      appBar: getAppBar('Story', context),
      body: isLoading
          ? getLoading(context)
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: story.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(
                                              story[index].imgUrl),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: getNormalText(
                                              story[index].title,
                                              15,
                                              MyColors.blueColor),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          var storyProvider =
                                              Provider.of<StoryProvider>(
                                                  context,
                                                  listen: false);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          story[index].imgUrl == ''
                                              ? null
                                              : await FirebaseStorage.instance
                                                  .refFromURL(
                                                      story[index].imgUrl)
                                                  .delete();
                                          await storyProvider
                                              .deleteStroy(story[index].id);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        icon: Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Add Caption', 15, MyColors.blueColor),
                      TextFormField(
                        controller: t1,
                        decoration: const InputDecoration(
                          icon: Icon(
                            Icons.text_fields,
                            color: MyColors.blueColor,
                          ),
                          hintText: 'Enter title',
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          title = newValue!;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      file == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Image.file(File(file!.path)),
                                  ),
                                  IconButton(
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
                        child: getBoldText('Add Story', 13, Colors.white),
                        onPressed: () {
                          file == null ? saveForm(' ') : uploadImage();
                        },
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   child: RaisedButton(
                      //     shape: StadiumBorder(),
                      //     color: MyColors.blueColor,
                      //     child: getBoldText(
                      //       'Add Notice',
                      //       15,
                      //       Colors.white,
                      //     ),
                      //     onPressed: () async {
                      //       var storyProvider = Provider.of<StoryProvider>(
                      //           context,
                      //           listen: false);
                      //       var authProvider = Provider.of<AuthProvider>(
                      //           context,
                      //           listen: false);

                      //       if (_formKey.currentState!.validate()) {
                      //         _formKey.currentState!.save();
                      //         setState(() {
                      //           isLoading = true;
                      //         });
                      //         noticeProvider
                      //             .addNotice(NoticeModel(
                      //                 id: 'a',
                      //                 title: title,
                      //                 content: 'content',
                      //                 datetime: DateTime.now().toString()))
                      //             .catchError((e) {
                      //           setState(() {
                      //             isLoading = false;
                      //           });
                      //           ScaffoldMessenger.of(context)
                      //               .showSnackBar(const SnackBar(
                      //             content: Text('Somethineg went wrong'),
                      //           ));
                      //         }).then((value) async {
                      //           await sendNotification('content', title,
                      //               authProvider.teacherOneSignalIds());

                      //           setState(() {
                      //             isLoading = false;
                      //           });
                      //           ScaffoldMessenger.of(context)
                      //               .showSnackBar(const SnackBar(
                      //             content: Text(' Notice Added Successfully'),
                      //           ));
                      //         });
                      //       }
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
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
    final dest = 'story_images/${file!.name}';
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
    saveForm(urlDownload);
  }

  saveForm(String url) {
    var storyProvider = Provider.of<StoryProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      var newStory = StoryModel(
        id: DateTime.now().toString(),
        datetime: DateTime.now().toString(),
        title: title,
        imgUrl: url,
      );
      storyProvider.addStory(newStory).catchError((error) {
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
          t1.clear();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Story Added'),
          ));
          // _showMyDialog();
        });

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => AddFees(
        //       parentModel:
        //           Provider.of<ParentsProvider>(context)
        //               .parents[0],
        //     ),
        //   ),
        // );
      });
    }
  }
}
