import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../../../../core/data/my_colors.dart';
import '../../../../../../../core/utils/circle_image.dart';
import '../../../../core/utils/human_readable_time.dart';
import '../../../domain/models/text_message.dart';
import '../../widgets/text_chat_adapter.dart';

class CommentCard extends StatefulWidget {
  CommentCard();

  @override
  CommentCardRouteState createState() => CommentCardRouteState();
}

class CommentCardRouteState extends State<CommentCard> {
// Comments
  bool showSend = false;
  final TextEditingController inputController = TextEditingController();
  List<TextMessage> items = [];
  late TextChatAdapter adapter;
  @override
  void initState() {
    super.initState();
    items.add(TextMessage.time(
        items.length,
        "Abebe",
        "This is very amazing, thank you for sharing",
        false,
        items.length % 5 == 0,
        formatDateTimeDifference(DateTime.now())));
    items.add(TextMessage.time(items.length, "Helen", "Wow amazing", true,
        items.length % 5 == 0, formatDateTimeDifference(DateTime.now())));
  }

  @override
  Widget build(BuildContext context) {
    adapter = TextChatAdapter(context, items, onItemClick);
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                      width: 30,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: MyColors.grey_10,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      )),
                ),
                const Center(
                  child: Text(
                    '4 Comments',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                ),
                Container(height: 10),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: adapter.getView(),
                    ),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.sentiment_satisfied,
                                  color: MyColors.grey_40),
                              onPressed: () {}),
                          Expanded(
                            child: TextField(
                              controller: inputController,
                              maxLines: 1,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration.collapsed(
                                  hintText: 'Add Comment'),
                              onChanged: (term) {},
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () {
                                sendMessage();
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void onItemClick(int index, String obj) {}

  void sendMessage() {
    String message = inputController.text;
    inputController.clear();
    showSend = false;
    setState(() {
      adapter.insertSingleItem(TextMessage.time(
          adapter.getItemCount(),
          "Michot",
          message,
          true,
          adapter.getItemCount() % 5 == 0,
          formatDateTimeDifference(DateTime.now())));
    });
  }
}
