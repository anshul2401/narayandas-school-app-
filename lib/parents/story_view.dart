import 'package:flutter/material.dart';
import 'package:narayandas_app/model/story_model.dart';
import 'package:narayandas_app/provider/story_provider.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class StoryHome extends StatelessWidget {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    List<StoryModel> story = [];
    var s = Provider.of<StoryProvider>(context);
    story.addAll(List.from(s.story.reversed));

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(
          0,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: 300,
              child: StoryView(
                controller: controller,
                storyItems: story.getRange(0, 3).map((e) {
                  return e.imgUrl == ' '
                      ? StoryItem.text(
                          title: e.title,
                          backgroundColor: Colors.orange,
                          roundedTop: true,
                        )
                      : StoryItem.inlineImage(
                          url: e.imgUrl,
                          controller: controller,
                          caption: Text(
                            e.title,
                            style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.black54,
                              fontSize: 17,
                            ),
                          ),
                        );
                }).toList(),
                onStoryShow: (s) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                },
                progressPosition: ProgressPosition.bottom,
                repeat: false,
                inline: true,
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MoreStories()));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: MyColors.blueColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<StoryModel> story = [];
    var s = Provider.of<StoryProvider>(context);
    story.addAll(List.from(s.story.reversed));
    return Scaffold(
      body: StoryView(
        controller: storyController,
        storyItems: story.getRange(3, story.length).map((e) {
          return e.imgUrl == ' '
              ? StoryItem.text(
                  title: e.title,
                  backgroundColor: Colors.orange,
                  roundedTop: true,
                )
              : StoryItem.inlineImage(
                  imageFit: BoxFit.fitHeight,
                  url: e.imgUrl,
                  controller: storyController,
                  caption: Text(
                    e.title,
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                      fontSize: 17,
                    ),
                  ),
                );
        }).toList(),
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.bottom,
        repeat: false,
        inline: true,
      ),
    );
  }
}

class MoreStoriesTeacher extends StatefulWidget {
  @override
  _MoreStoriesTeacherState createState() => _MoreStoriesTeacherState();
}

class _MoreStoriesTeacherState extends State<MoreStoriesTeacher> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<StoryModel> story = [];
    var s = Provider.of<StoryProvider>(context);
    story.addAll(List.from(s.story.reversed));
    return Scaffold(
      body: StoryView(
        controller: storyController,
        storyItems: story.map((e) {
          return e.imgUrl == ' '
              ? StoryItem.text(
                  title: e.title,
                  backgroundColor: Colors.orange,
                  roundedTop: true,
                )
              : StoryItem.inlineImage(
                  imageFit: BoxFit.fitHeight,
                  url: e.imgUrl,
                  controller: storyController,
                  caption: Text(
                    e.title,
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                      fontSize: 17,
                    ),
                  ),
                );
        }).toList(),
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.bottom,
        repeat: false,
        inline: true,
      ),
    );
  }
}
