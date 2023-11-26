import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../../../../core/data/my_colors.dart';
import '../../../../../../../core/utils/circle_image.dart';

// Comments
bool showSend = false;
final TextEditingController inputController = TextEditingController();
Widget voiceCard(BuildContext context) {
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
                    decoration: BoxDecoration(
                      color: MyColors.grey_10,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )),
              ),
              const Center(
                child: Text(
                  '4 Voice Comments',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 33, 33, 33),
                  ),
                ),
              ),
              Container(height: 10),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xffffffff), // Set the background color
                      borderRadius:
                          BorderRadius.circular(15), // Set the border radius
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleImage(
                              size: 40,
                              imageProvider:
                                  AssetImage('assets/images/profile_3.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            // user circular profile photo and name, post date
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Helen Mesfin',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 26, 26, 26),
                                  ),
                                ),
                                Text(
                                  "2 hour ago",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff6B6F74),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          )
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 45, right: 8, top: 2),
                            child: VoiceMessage(
                              audioSrc:
                                  'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
                              played: false,
                              me: true,
                              meBgColor: Colors.blueAccent,
                              onPlay: () {}, // Do something when voice played.
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 35, right: 8, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      // tint color
                                      color:
                                          const Color.fromARGB(255, 49, 49, 49),
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
                                    "340",
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
                                    "10",
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
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 245, 245, 245),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xffffffff), // Set the background color
                      borderRadius:
                          BorderRadius.circular(15), // Set the border radius
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleImage(
                              size: 40,
                              imageProvider:
                                  AssetImage('assets/images/profile_3.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            // user circular profile photo and name, post date
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Helen Mesfin',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 26, 26, 26),
                                  ),
                                ),
                                Text(
                                  "2 hour ago",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff6B6F74),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          )
                        ]),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 45, right: 8, top: 2),
                            child: VoiceMessage(
                              audioSrc:
                                  'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
                              played: false,
                              me: true,
                              meBgColor: Colors.blueAccent,
                              onPlay: () {}, // Do something when voice played.
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 35, right: 8, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      // tint color
                                      color:
                                          const Color.fromARGB(255, 49, 49, 49),
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
                                    "340",
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
                                    "10",
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
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 245, 245, 245),
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
                            icon: const Icon(Icons.mic, color: Colors.blue),
                            onPressed: () {}),
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
