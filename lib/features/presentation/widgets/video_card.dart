import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploading/features/domain/models/video.dart';
import 'package:video_uploading/features/presentation/screens/comments/show_voice_comment.dart';
import 'package:video_uploading/features/data/datasources/like_video.dart';
import 'package:chewie/chewie.dart';
import 'package:video_uploading/features/data/datasources/post_comment.dart';
import 'package:video_uploading/features/presentation/widgets/comment_view.dart';
import 'package:just_audio/just_audio.dart';

import '../screens/comments/show_comment.dart';

class PlayVideoCard extends StatefulWidget {
  const PlayVideoCard(
      {super.key,
      required this.post_id,
      required this.videoURL,
      required this.imageURL,
      required this.audioURL,
      required this.videoName,
      required this.Likes,
      required this.time});

  final int? post_id;
  final String? videoURL;
  final String? imageURL;
  final String? audioURL;
  final String? videoName;
  final int Likes;
  final String? time;
  @override
  State<PlayVideoCard> createState() => _PlayVideoCardState();
}

class _PlayVideoCardState extends State<PlayVideoCard> {
  late Query databaseReference;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  // late ChewieController _chewieController;
  TextEditingController commentController = TextEditingController();
  late VideoPlayerController _controller;
  List<Map<dynamic, dynamic>> likes = [];
  bool isPlaying = false;
  bool isLiked = false;
  String like_no = "0";
  // late BuildContext _scaffoldCtx;

  late PersistentBottomSheetController sheetController;
  late PersistentBottomSheetController sheetController2;

  bool showComment = false;
  bool showVoice = false;

  // audio controllers
  late AudioPlayer _audioPlayer;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration _bufferedPosition = Duration.zero;
  bool _isDragging = false;

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    commentController.dispose();
    _audioPlayer.dispose();

    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    if (widget.audioURL != null) {
      await _audioPlayer.setUrl(widget.audioURL!);
      // Listen for changes in audio player state
      _audioPlayer.durationStream.listen((event) {
        setState(() {
          _duration = event ?? Duration.zero;
        });
      });

      _audioPlayer.positionStream.listen((event) {
        setState(() {
          _bufferedPosition = event ?? Duration.zero;
        });
      });
    } else {
      // Handle the case when audioURL is null, e.g., show an error message
      print('Error: audioURL is null');
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
    _videoPlayerController =
        VideoPlayerController.network(widget.videoURL ?? '');
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: true,
      autoPlay: true,
    );
    databaseReference = FirebaseDatabase.instance
        .ref()
        .child('Likes')
        .orderByChild('postId')
        .equalTo(widget.post_id);
    loadLikes();
  }

  void loadLikes() {
    log("Loading posts...");
    databaseReference.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        dynamic value = snapshot.value;
        if (value is Map<dynamic, dynamic>) {
          List<Map<dynamic, dynamic>> likes = [];
          value.forEach((key, likeData) {
            Map<dynamic, dynamic> like = {
              'comment_id': key,
              'user_id': likeData['user_id'],
              'post_id': likeData['post_id'],
              'like': likeData['like'],
            };
            likes.add(like);
          });
          setState(() {
            this.likes = likes;
          });
        } else {
          log("Can't Iterate Snapshot");
        }
      } else {
        log("Can't load data");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioURL == null
        ? Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.089),
                  blurRadius: 24,
                  offset: Offset(0, -2), // Change the vertical offset to -2
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      const CircleAvatar(
                        radius: 18,
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7),
                          Text(
                            "${widget.videoName}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${widget.time}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // color: Color(0XFFF0F0FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 450,
                    child: widget.videoURL != null
                        ? Chewie(
                            controller: _chewieController,
                          )
                        : widget.imageURL != null
                            ? Image.network(
                                widget.imageURL!,
                                fit: BoxFit.cover,
                              )
                            : Chewie(
                                controller: _chewieController,
                              ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // share
                          const Text(
                            '1',
                            style: TextStyle(color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () async {
                              print('share pressed');
                              Share.share(
                                  'check out my website https://akababi.com/share/post_id=122129876');
                            },
                            icon: const Icon(
                              Icons.share,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          // comment
                          const Text(
                            '2',
                            style: TextStyle(color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                showComment = !showComment;
                                if (showComment) {
                                  _showComments(context);
                                  print("------------ displayed");
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.comment,
                              color: Color.fromRGBO(23, 23, 23, 1),
                              size: 25,
                            ),
                          ),
                          const Spacer(),
                          // voice
                          const Text(
                            '0',
                            style: TextStyle(color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                showVoice = !showVoice;
                                if (showVoice) {
                                  _showVoice(context);
                                  print("------------ displayed");
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                              print('Record button pressed');
                            },
                            icon: const Icon(
                              Icons.mic,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),

                          // Like
                          Text(
                            like_no,
                            style: const TextStyle(color: Colors.black),
                          ), // Like number goes here
                          IconButton(
                            onPressed: () async {
                              print('Like pressed');
                              await LikePost(widget.post_id!);

                              setState(() {
                                isLiked = !isLiked;
                                isLiked
                                    ? like_no = (widget.Likes + 1).toString()
                                    : like_no =
                                        (int.parse(like_no) - 1).toString();
                              });
                            },
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      //   Container(
                      //     width: 370,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.black),
                      //     ),
                      //     child: TextField(
                      //       style: const TextStyle(
                      //           color: Colors.black, fontSize: 12),
                      //       controller: commentController,
                      //       decoration: InputDecoration(
                      //         contentPadding: const EdgeInsets.only(left: 8),
                      //         hintText: 'Add Comment ...',
                      //         hintStyle: const TextStyle(
                      //             color: Colors.black, fontSize: 12),
                      //         border: InputBorder.none,
                      //         suffixIcon: IconButton(
                      //           onPressed: () {
                      //             String _comment = commentController.text;
                      //             PostComment(_comment, widget.post_id);
                      //             setState(() {
                      //               commentController.clear();
                      //             });
                      //             print('Send comment $_comment');
                      //           },
                      //           icon: const Icon(Icons.send),
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(149, 157, 165, 0.089),
                  blurRadius: 24,
                  offset: Offset(0, -2), // Change the vertical offset to -2
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      const CircleAvatar(
                        radius: 18,
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 7),
                          Text(
                            "${widget.videoName}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${widget.time}",
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          if (_audioPlayer.playing) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play();
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Slider(
                          value: _position.inSeconds.toDouble(),
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              _isDragging = true;
                              _position = Duration(seconds: value.toInt());
                            });
                          },
                          onChangeEnd: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                            _isDragging = false;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void _showComments(scaffoldCtx) {
    Navigator.of(context, rootNavigator: true);
    sheetController = showBottomSheet(
        context: scaffoldCtx,
        builder: (BuildContext bc) {
          return CommentCard(id: widget.post_id!);
        });
    sheetController.closed.then((value) {
      setState(() {
        showComment = false;
      });
    });
  }

  void _showVoice(scaffoldCtx) {
    Navigator.of(context, rootNavigator: true);
    sheetController2 = showBottomSheet(
        context: scaffoldCtx,
        builder: (BuildContext bc) {
          return VoiceCommentCard();
        });
    sheetController2.closed.then((value) {
      setState(() {
        showVoice = false;
      });
    });
  }
}
