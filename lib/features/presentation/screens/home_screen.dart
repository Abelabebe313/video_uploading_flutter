import 'dart:io';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_uploading/features/presentation/screens/video_upload_screen.dart';
import 'package:video_uploading/features/presentation/widgets/video_card.dart';

import '../../data/datasources/remote_data_source.dart';
import '../../data/models/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('Posts');

  List<Map<dynamic, dynamic>> posts = [];
  final remoteDataSource = RemoteDataSource();

  @override
  void initState() {
    super.initState();
    // loadPosts();
    checkAndRequestPermission();
    getPostsData();
  }

  Future<void> checkAndRequestPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      // Permission already granted
      print('Location permission already granted');
    } else {
      // Permission not granted, request it
      await requestLocationPermission();
    }
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted, you can now use location services
      print('Location permission granted');
    } else {
      // Permission denied
      print('Location permission denied');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getPostsData() async {
    try {
      final List<Post> postList = await remoteDataSource.getAllPost();
      print(postList.runtimeType);
      print(postList);
      setState(() {
        // Convert the list of Post objects to the format you need
        posts = postList.map((post) => post.toJson()).toList();
      });
    } catch (e) {
      // Handle errors
      print('HomeError fetching posts: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void loadPosts() {
    developer.log("Loading posts...");
    databaseReference.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        dynamic value = snapshot.value;
        if (value is Map<dynamic, dynamic>) {
          List<Map<dynamic, dynamic>> posts = [];
          value.forEach((key, postData) {
            Map<dynamic, dynamic> post = {
              'post_id': key,
              'author': postData['author'],
              'videoLink': postData['videoLink'],
              'title': postData['title'],
              'created_at': postData['created_at'],
              'likes': postData['likes'],
            };
            posts.add(post);
          });
          setState(() {
            this.posts = posts;
            // sort in reverse order
            this
                .posts
                .sort((a, b) => b['created_at'].compareTo(a['created_at']));
            developer.log("posts loaded successfully! ");
          });
        } else {
          // Handle the case when `snapshot.value` is not a Map<dynamic, dynamic>
          developer.log("Can't Iterate Snapshot");
        }
      } else {
        // Handle the case when `snapshot.value` is null
        developer.log("Can't load data");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFF),
        title: const Text(
          'Akababi',
          style: TextStyle(
              fontFamily: "DancingScript",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.91,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> post = posts[index];
                  int id = post['id'];
                  String author = "post['author']";
                  String videoLink =
                      "https://api.redwolfsoft.com/" + post['videoContents'][0];
                  String title = "post['title']";
                  String time = post['createdAt'];
                  int likes = 0;

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    // margin: const EdgeInsets.fromLTRB(30,0,0,10),
                    child: PlayVideoCard(
                      post_id: id,
                      videoURL: videoLink,
                      videoName: author,
                      Likes: likes,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: ((context) => VideoUpload())));
      //   },
      //   child: const Icon(Icons.add_a_photo),
      // ),
    );
  }
}
