import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import '../../../core/data/my_colors.dart';
import '../../../core/data/my_text.dart';
import '../../../core/utils/circle_image.dart';
import '../../domain/models/text_message.dart';
import 'random_profile_pic.dart';

class TextChatAdapter {
  List items = <TextMessage>[];
  BuildContext context;
  Function onItemClick;
  ScrollController scrollController = ScrollController();

  TextChatAdapter(this.context, this.items, this.onItemClick);

  void insertSingleItem(TextMessage msg) {
    int insertIndex = items.length;
    items.insert(insertIndex, msg);
    scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  Widget getView() {
    return Container(
      child: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        controller: scrollController,
        itemBuilder: (context, index) {
          TextMessage item = items[index];
          return buildListItemView(index, item);
        },
      ),
    );
  }

  Widget buildListItemView(int index, TextMessage item) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: RandomColorCircleAvatar(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 26, 26, 26),
                      ),
                    ),
                    Text(
                      item.date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff6B6F74),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 1,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 8, top: 2),
            child: ExpandableText(
              item.content,
              animation: true,
              collapseOnTextTap: true,
              linkColor: const Color.fromARGB(255, 68, 186, 254),
              expandText: "More",
              collapseText: 'show less',
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: Color.fromARGB(255, 37, 37, 37),
              ),
              onHashtagTap: (name) {
                // showHashtag(name)
              },
              hashtagStyle: const TextStyle(
                color: Color(0xffFEBE44),
              ),
              onMentionTap: (username) {
                // showProfile(username)
              },
              mentionStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              urlStyle: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 8, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        color: const Color.fromARGB(255, 49, 49, 49),
                        splashRadius: 10,
                        iconSize: 25,
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "0",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 36, 36, 36),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const Icon(
                      Icons.comment,
                      color: Color.fromARGB(255, 22, 22, 22),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "0",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 48, 48, 48),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    const Icon(
                      Icons.flag_outlined,
                      color: Color.fromARGB(255, 51, 51, 51),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getItemCount() => items.length;
}
