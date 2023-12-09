import 'package:video_uploading/features/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getAllPost();
  Future<Map<dynamic, dynamic>> videoPost(Map<dynamic, dynamic> postData);
  Future<Map<dynamic,dynamic>> imagePost(Map<dynamic,dynamic> postData);
  Future<Map<dynamic,dynamic>> audioPost(Map<dynamic,dynamic> postData);

  Future<List<Post>> myPost();
}
