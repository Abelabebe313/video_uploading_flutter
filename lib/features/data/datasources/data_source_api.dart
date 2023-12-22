import 'package:video_uploading/features/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getAllPost();
  Future<Map<dynamic, dynamic>> videoPost(Map<dynamic, dynamic> postData);
  Future<Map<dynamic,dynamic>> imagePost(Map<dynamic,dynamic> postData);
  Future<Map<dynamic,dynamic>> audioPost(Map<dynamic,dynamic> postData);
  Future<Map<dynamic,dynamic>> commentPost(Map<dynamic,dynamic> commentData);
  Future<Map<dynamic,dynamic>> reactPost(Map<dynamic,dynamic> reactionData);

  Future<List<Post>> myPost();
}
