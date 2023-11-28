import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;
String name = '';

class StoreData {
  Future<String> uploadVideo(String videoUrl) async {
    Reference ref =
        storage.ref().child('videos/${DateTime.now().toString()}.mp4');
    await ref.putFile(File(videoUrl));
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveVideoData(String videoDownloadUrl) async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Users/${user!.uid}').get();

    if (snapshot.value != null) {
      final Map<dynamic, dynamic>? data =
          snapshot.value as Map<dynamic, dynamic>?;

      // upload to realtime db
      DatabaseReference dref = FirebaseDatabase.instance.ref().child("Posts");

// Generate a new child reference with a unique ID
      DatabaseReference newPostRef = dref.push();
// Now, upload the data to the new child reference
      await newPostRef.set({
        "author_id": user!.uid,
        "author": data!['firstName'],
        "videoLink": videoDownloadUrl,
        "title": "",
        "created_at": '${DateTime.now()}',
        "likes": 0,
      });
    }
    // await firestore.collection('videos').add({
    //   'url': videoDownloadUrl,
    //   'createdAt': FieldValue.serverTimestamp(),
    //   'name': 'User video'
    // });
  }
}
