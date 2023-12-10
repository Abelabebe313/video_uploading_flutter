import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media_audio_recorder/social_media_audio_recorder.dart';
import 'package:video_uploading/core/data/my_colors.dart';
import 'package:video_uploading/features/domain/models/voice_message.dart';
import 'package:video_uploading/features/presentation/widgets/voice_chat_adapter.dart';

class VoiceCommentCard extends StatefulWidget {
  const VoiceCommentCard({Key? key}) : super(key: key);

  @override
  _VoiceCommentCardState createState() => _VoiceCommentCardState();
}

class _VoiceCommentCardState extends State<VoiceCommentCard>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  String filepath = "";
  bool readOnly = false;
  // ----
  final TextEditingController inputController = TextEditingController();
  List<VoiceMessageModel> items = [];
  late VoiceChatAdapter adapter;
  IconData currentIcon = Icons.mic;
  bool isRecording = false;
  int recordDuration = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    super.initState();
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
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 19),
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  readOnly: readOnly,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        RecordButton(
                          color: const Color.fromARGB(255, 0, 60, 163),
                          allTextColor: Colors.white,
                          controller: controller!,
                          arrowColor: Colors.white,
                          onRecordEnd: (String value) {
                            setState(() {
                              filepath = value;
                              readOnly = false;
                            });
                            sendMessage();
                          },
                          onRecordStart: () {
                            setState(() {
                              readOnly = true;
                            });
                          },
                          onCancelRecord: () {
                            setState(() {
                              readOnly = false;
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
    String message = filepath;
    inputController.clear();
    setState(() {
      adapter.insertSingleItem(VoiceMessageModel.time(
          adapter.getItemCount(),
          "Michot",
          message,
          const Color.fromARGB(255, 6, 22, 129),
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
