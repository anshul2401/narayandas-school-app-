import 'package:narayandas_app/chat2/model/user.dart';
import 'package:narayandas_app/chat2/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:narayandas_app/utils/colors.dart';
import 'package:narayandas_app/utils/strings.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;

  const ChatHeaderWidget({
    required this.users,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: MyColors.blueColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                'Hello, ' + currentUser!.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // SizedBox(height: 12),
            // Container(
            //   height: 60,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: users.length,
            //     itemBuilder: (context, index) {
            //       final user = users[index];
            //       if (index == 0) {
            //         return Container(
            //           margin: EdgeInsets.only(right: 12),
            //           child: CircleAvatar(
            //             radius: 24,
            //             child: Icon(Icons.search),
            //           ),
            //         );
            //       } else {
            //         return Container(
            //           margin: const EdgeInsets.only(right: 12),
            //           child: GestureDetector(
            //             onTap: () {
            //               Navigator.of(context).push(MaterialPageRoute(
            //                 builder: (context) => ChatPage(user: users[index]),
            //               ));
            //             },
            //             child: CircleAvatar(
            //               radius: 24,
            //               backgroundImage: NetworkImage(user.urlAvatar),
            //             ),
            //           ),
            //         );
            //       }
            //     },
            //   ),
            // )
          ],
        ),
      );
}
