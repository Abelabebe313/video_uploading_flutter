import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_uploading/bloc/bloc.dart';
import 'package:video_uploading/bloc/postEvent.dart';
import 'package:video_uploading/bloc/postState.dart';
import 'package:video_uploading/features/presentation/screens/video_upload_screen.dart';
import 'package:video_uploading/features/presentation/widgets/home_shimmer.dart';
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
  final postBloc = PostBloc(postRemoteDataSource: RemoteDataSource());
  static const String postsKey = 'posts';

  @override
  void initState() {
    super.initState();
    // loadPosts();
    postBloc.add(GetAllPostEvent());
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
    postBloc.close();
  }

  Future<void> getPostsData() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await loadPostsFromSharedPreferences();
      } else {
        // Internet connection, fetch from Bloc
        postBloc.add(GetAllPostEvent());
      }

      // Fetch posts from the remote data source
      final List<Post> postList = await remoteDataSource.getAllPost();

      setState(() {
        // Convert the list of Post objects to the format you need
        posts = postList.map((post) => post.toJson()).toList();
      });

      // Save fetched posts to SharedPreferences
      savePostsToSharedPreferences(posts.cast<Post>());
    } catch (e) {
      // Handle errors
      print('HomeError fetching posts: $e');

      // Display an error message or take appropriate action
    }
  }

  // Save posts to SharedPreferences
  Future<void> savePostsToSharedPreferences(List<Post> posts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(postsKey, jsonEncode(posts));
  }

  // Load posts from SharedPreferences
  Future<void> loadPostsFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedPosts = prefs.getString(postsKey);

    if (savedPosts != null) {
      setState(() {
        posts = List<Map<dynamic, dynamic>>.from(jsonDecode(savedPosts));
      });
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      bloc: postBloc,
      builder: (context, state) {
        if (state is PostLoading) {
          return const Shimmer();
        } else if (state is LoadedGetPostState) {
          savePostsToSharedPreferences(state.posts);
          return _buildPostsList(state.posts);
        } else if (state is PostError) {
          return _buildErrorUI(state.errorMessage);
        } else {
          return _buildInitialUI();
        }
      },
    );
  }

  Widget _buildPostsList(List<Post> posts) {
    return RefreshIndicator(
      onRefresh: () async {
        postBloc.add(GetAllPostEvent());
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xffF8FAFF),
          title: const Text(
            'Akababi',
            style: TextStyle(
              fontFamily: "DancingScript",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
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
                height: MediaQuery.of(context).size.height * 0.85,
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    Post post = posts[index];
                    int? id = post.id;
                    // String author = "post['author']";
                    // String videoLink = "https://api.redwolfsoft.com/assets/" +
                    //     post['videoContents'][0];
                    String? textContent = post.textContent;
                    String? time = post.createdAt;
                    int likes = 0;
                    List<String> audioContents = post.audioContents ?? [];
                    List<String> videoContents = post.videoContents ?? [];
                    List<String> imageContents = post.imageContents ?? [];
                    String? audioLink = audioContents.isNotEmpty
                        ? "https://api.redwolfsoft.com/assets/" +
                            audioContents[0]
                        : null;
                    String? videoLink = videoContents.isNotEmpty
                        ? "https://api.redwolfsoft.com/assets/" +
                            videoContents[0]
                        : null;
                    String? imageLink = imageContents.isNotEmpty
                        ? "https://api.redwolfsoft.com/assets/" +
                            imageContents[0]
                        : null;

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      // margin: const EdgeInsets.fromLTRB(30,0,0,10),
                      child: PlayVideoCard(
                        post_id: id,
                        videoURL: videoLink,
                        imageURL: imageLink,
                        audioURL: audioLink,
                        videoName: textContent,
                        Likes: likes,
                        time: time,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorUI(String errorMessage) {
    // Implement UI for error state
    return Center(
      child: Text('Error: $errorMessage'),
    );
  }

  Widget _buildInitialUI() {
    // Implement UI for initial state
    return Center(
      child: Text('Initial state'),
    );
  }
}
