import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploading/models/video.dart';
import 'package:video_uploading/service/like_video.dart';
import 'package:chewie/chewie.dart';
import 'package:video_uploading/service/post_comment.dart';
import 'package:video_uploading/widgets/comment_view.dart';

class PlayVideoCard extends StatefulWidget {
  const PlayVideoCard(
      {super.key,
      required this.post_id,
      required this.videoURL,
      required this.videoName,
      required this.Likes});

  final String post_id;
  final String videoURL;
  final String videoName;
  final int Likes;
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

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoURL);
    _videoPlayerController.initialize().then((_) {
      setState(() {});
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      looping: true,
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
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
  //   // _controller.setLooping(true);
  //   _controller.initialize().then((_) => setState(() {}));
  //   // _controller.play();
  //   _chewieController = ChewieController(
  //     videoPlayerController: _controller,
  //     // aspectRatio: 16 / 9,
  //     autoInitialize: true,
  //     looping: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 135,
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
                      widget.videoName,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const Text(
                      '5h',
                      style: TextStyle(
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
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              // color: Color(0XFFF0F0FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Chewie(
              controller: _chewieController,
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // share
                  const Text(
                    '5k',
                    style:  TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () async {
                      print('share pressed');
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
                    '5k',
                    style:  TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () async {
                      print('comments pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Comments(
                            post_id: widget.post_id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.message,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  // voice
                  const Text(
                    '5k',
                    style:  TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () async {
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
                    '${widget.Likes}',
                    style: const TextStyle(color: Colors.black),
                  ), // Like number goes here
                  IconButton( 
                    onPressed: () async {
                      print('Like pressed');
                      await LikePost(widget.Likes + 1, widget.post_id);
                      setState(() {
                        isLiked = !isLiked;
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
              Container(
                width: 370,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  controller: commentController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    hintText: 'Add Comment ...',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        String _comment = commentController.text;
                        PostComment(_comment, widget.post_id);
                        setState(() {
                          commentController.clear();
                        });
                        print('Send comment $_comment');
                      },
                      icon: Icon(Icons.send),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
