import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Comments extends StatefulWidget {
  final String post_id;
  const Comments({Key? key, required this.post_id}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late Query databaseReference;
  
  List<Map<dynamic, dynamic>> comments = [];
  @override
  initState() {
    super.initState();
    databaseReference =
      FirebaseDatabase.instance.ref().child('Comments').orderByChild('postId').equalTo(widget.post_id);
    loadComments();
  }

  void loadComments() {
    log("Loading posts...");
    databaseReference.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        dynamic value = snapshot.value;
        if (value is Map<dynamic, dynamic>) {
          List<Map<dynamic, dynamic>> comments = [];
          value.forEach((key, commentData) {
            Map<dynamic, dynamic> comment = {
              'comment_id': key,
              'user_id': commentData['user_id'],
              'post_id': commentData['post_id'],
              'comment': commentData['comment'],
              'commentedAt': commentData['commentedAt'],
            };
            comments.add(comment);
          });
          setState(() {
            this.comments = comments;
            // sort in reverse order
            this
                .comments
                .sort((a, b) => b['created_at'].compareTo(a['created_at']));
            log("posts loaded successfully! ");
          });
        } else {
          // Handle the case when `snapshot.value` is not a Map<dynamic, dynamic>
          log("Can't Iterate Snapshot");
        }
      } else {
        // Handle the case when `snapshot.value` is null
        log("Can't load data");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.91,
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> commentData = comments[index];

                  // String user_id = commentData['user_id'];
                  // String post_id = commentData['post_id'];
                  String comment = commentData['comment'];
                  String commentedAt = commentData['commentedAt'];
                  if (comments.length == null) {
                    return Center(
                      child: Text('No Comments'),
                    );
                  } else {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(comment),
                            subtitle: Text(commentedAt),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
