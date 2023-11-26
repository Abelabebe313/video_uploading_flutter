import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;

// ignore: non_constant_identifier_names

Future<void> LikePost(int like, String postId) async {
  DatabaseReference dref = FirebaseDatabase.instance.ref().child("Likes");
   DatabaseReference newPostRef = dref.push();
// Now, upload the data to the new child reference
      await newPostRef.set({
        "user_id": user!.uid,
        "postId":postId,
        "like": like,
      });
    }

