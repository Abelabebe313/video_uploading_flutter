import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_uploading/core/data/my_colors.dart';
import 'package:video_uploading/features/domain/models/voice_message.dart';
import 'package:video_uploading/features/presentation/widgets/voice_chat_adapter.dart';

class VoiceCommentCard extends StatefulWidget {
  const VoiceCommentCard({Key? key}) : super(key: key);

  @override
  _VoiceCommentCardState createState() => _VoiceCommentCardState();
}

class _VoiceCommentCardState extends State<VoiceCommentCard> {
  final TextEditingController inputController = TextEditingController();
  List<VoiceMessageModel> items = [];
  late VoiceChatAdapter adapter;
  IconData currentIcon = Icons.mic;
  bool isRecording = false;
  int recordDuration = 0;

  @override
  void initState() {
    super.initState();
    // items.add(VoiceMessageModel.time(
    //     items.length,
    //     "Abebe",
    //     "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
    //     Color.fromARGB(255, 21, 21, 21),
    //     false,
    //     items.length % 5 == 0,
    //     formatDateTimeDifference(DateTime.now())));
    // items.add(VoiceMessageModel.time(
    //     items.length,
    //     "Helen",
    //     "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
    //     Color.fromARGB(255, 21, 21, 21),
    //     true,
    //     items.length % 5 == 0,
    //     formatDateTimeDifference(DateTime.now())));
  }

  @override
  Widget build(BuildContext context) {
    adapter = VoiceChatAdapter(context, items, onItemClick);
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
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Comments',
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
                          icon:
                              const Icon(Icons.attach_file, color: Colors.grey),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            maxLines: 1,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            enabled:
                                false, // Set to false to disable the text field
                            decoration: InputDecoration.collapsed(
                              hintText: isRecording
                                  ? "${formatDuration(recordDuration)} Recording Start.."
                                  : 'Add audio comment',
                            ),
                            onChanged: (term) {},
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            currentIcon,
                            color: isRecording ? Colors.red : Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isRecording) {
                                // Pause recording logic
                                setState(() {
                                  isRecording = false;
                                  currentIcon = Icons.mic;
                                });
                                // Add your logic to handle the recorded voice here
                                print('Recording paused');
                                sendMessage();
                              } else {
                                // Start recording logic
                                setState(() {
                                  isRecording = true;
                                  currentIcon = Icons.stop;
                                  recordDuration = 0;
                                });
                                // Start a timer to update the record duration
                                Timer.periodic(Duration(seconds: 1), (timer) {
                                  if (!isRecording) {
                                    timer.cancel();
                                  } else {
                                    setState(() {
                                      recordDuration++;
                                    });
                                  }
                                });
                                print('Recording started');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemClick(int index, String obj) {}

  void sendMessage() {
    String message = inputController.text;
    inputController.clear();
    setState(() {
      adapter.insertSingleItem(VoiceMessageModel.time(
          adapter.getItemCount(),
          "Michot",
          message,
          Color.fromARGB(255, 6, 22, 129),
          true,
          adapter.getItemCount() % 5 == 0,
          formatDateTimeDifference(DateTime.now())));
    });
  }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatDateTimeDifference(DateTime dateTime) {
    // Add your logic to format date time difference here
    return '';
  }
}
