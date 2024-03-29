import 'package:narayandas_app/chat2/model/user.dart';
import 'package:narayandas_app/chat2/widget/messages_widget.dart';
import 'package:narayandas_app/chat2/widget/new_message_widget.dart';
import 'package:narayandas_app/chat2/widget/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:narayandas_app/utils/colors.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: MyColors.blueColor,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user.name),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(25),
                    //   topRight: Radius.circular(25),
                    // ),
                  ),
                  child: MessagesWidget(idUser: widget.user.idUser),
                ),
              ),
              NewMessageWidget(idUser: widget.user.idUser)
            ],
          ),
        ),
      );
}
