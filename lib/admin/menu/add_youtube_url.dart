import 'package:flutter/material.dart';
import 'package:narayandas_app/model/about_model.dart';
import 'package:narayandas_app/model/youtube_model.dart';
import 'package:narayandas_app/provider/about_provider.dart';
import 'package:narayandas_app/provider/youtube_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeUrl extends StatefulWidget {
  const YoutubeUrl({Key? key}) : super(key: key);

  @override
  _YoutubeUrlState createState() => _YoutubeUrlState();
}

class _YoutubeUrlState extends State<YoutubeUrl> {
  var _formKey = GlobalKey<FormState>();
  late String url = '';
  late String id = '';
  YoutubePlayerController? _yc;

  TextEditingController t1 = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero).then((value) {
      Provider.of<YoutubeProvider>(context, listen: false)
          .fetchAndSetYoutube()
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
    var youtubeProvider = Provider.of<YoutubeProvider>(context, listen: false);

    t1.text = youtubeProvider.youtubeModel[0].url;
    setState(() {
      id = youtubeProvider.youtubeModel[0].id;
    });
    _yc = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(t1.text)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        isLive: false,
      ),
    );

    return Scaffold(
      appBar: getAppBar('Edit Youtube url', context),
      body: isLoading
          ? getLoading(context)
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _yc!,
                    ),
                    builder: (context, player) {
                      return Center(child: player);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: t1,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.text_fields,
                        color: MyColors.blueColor,
                      ),
                      hintText: 'Enter some url',
                      labelText: 'Youtube link',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      url = newValue!;
                    },
                  ),
                  RaisedButton(
                      child: getNormalText('Save', 15, Colors.black),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var youtubeProvider = Provider.of<YoutubeProvider>(
                              context,
                              listen: false);
                          setState(() {
                            isLoading = true;
                          });
                          _formKey.currentState!.save();
                          var newyt = YoutubeModel(
                              id: DateTime.now().toString(), url: url);
                          youtubeProvider
                              .updateYoutube(id, newyt)
                              .catchError((error) {
                            setState(() {
                              isLoading = false;
                            });
                            return ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Somethineg went wrong'),
                            ));
                          }).then((value) {
                            setState(() {
                              // meals.add(newMeal);
                              isLoading = false;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Youtube updated'),
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
                      })
                ],
              ),
            ),
    );
  }
}
