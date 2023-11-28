import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_uploading/features/domain/models/voice_message.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceChatAdapter {
  List items = <VoiceMessageModel>[];
  BuildContext context;
  Function onItemClick;
  ScrollController scrollController = ScrollController();

  VoiceChatAdapter(this.context, this.items, this.onItemClick);

  void insertSingleItem(VoiceMessageModel msg) {
    int insertIndex = items.length;
    items.insert(insertIndex, msg);
    scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  Widget getView() {
    return items.isEmpty
        ? const Center(
            child: Text(
              'No comments',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : Container(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              controller: scrollController,
              itemBuilder: (context, index) {
                VoiceMessageModel item = items[index];
                return buildListItemView(index, item);
              },
            ),
          );
  }

  Widget buildListItemView(int index, VoiceMessageModel item) {
    Color randomColor = getRandomColor();

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
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: item.color,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
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
              child: VoiceMessage(
                audioSrc:
                    'https://tg-cloud-file-small-file.ajz.workers.dev/music/file_119763.mp3?file_name=test-audio.mp3&expire=1701165308&signature=yA1FBlPEWxx1jljJF4qGDGmnXVNp%2BCYQAnaQxXNAhlk%3D',
                played: false,
                me: true,
                meBgColor: Colors.blueAccent,
                onPlay: () {}, // Do something when voice played.
              )),
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

Color getRandomColor() {
  // Generate a random color with full opacity
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}
