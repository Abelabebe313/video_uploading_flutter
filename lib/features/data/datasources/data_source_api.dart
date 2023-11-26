import 'package:video_uploading/features/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getAllPost();
  Future<Map<String, dynamic>> addPost(Map<String, dynamic> postData);

  Future<List<Post>> myPost();
}
