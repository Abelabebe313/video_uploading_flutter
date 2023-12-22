import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_uploading/features/data/datasources/remote_data_source.dart';


// ignore: non_constant_identifier_names
final remoteDataSource = RemoteDataSource();
Future<void> LikePost(int postId) async {
  
  Map<dynamic, dynamic> reactionData = {
      'reaction_id': '4',
      'post_id': '$postId',
    };
  Map<dynamic, dynamic> result = await remoteDataSource.reactPost(reactionData);
    if (result['status'] == 'success') {
          print('========>>>>>Reacting successfully<<<<==========');
          // Do something on success, if needed
        } else {
          print(
              '========>>>>>Failed to React: ${result['message']}<<<<==========');
          // Handle error, if needed
        }
}
