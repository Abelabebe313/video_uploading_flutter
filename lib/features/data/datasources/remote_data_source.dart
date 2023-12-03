import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:video_uploading/features/data/models/post.dart';
import 'package:http/http.dart' as http;
import 'data_source_api.dart';

class RemoteDataSource implements PostRemoteDataSource {
  RemoteDataSource();

  Future<dynamic> _fetchData(String endpoint) async {
    print('https://api.redwolfsoft.com/api/post/self');

    // Get the current location coordinates
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;
    Map<String, double> locationData = {
      'latitude': latitude,
      'longitude': longitude,
    };
    try {
      final response = await http.get(
        Uri.parse('https://api.redwolfsoft.com/api/post/self'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNKWmFvVDBYWnFkb1BKMnpOWlJ4UyJ9.eyJpc3MiOiJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2NTYyNGI5ZjE3YjRiZGI1MDExMzUxZDgiLCJhdWQiOlsiaHR0cHM6Ly9ha2FiYWJpLWFwaS5jb20iLCJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3MDA5NDA3NTAsImV4cCI6MTcwMzIyNzE0OCwiYXpwIjoiVnFmVkdYSlNUWXdQMkZJa2RkWFYxMDZiMkJyRXF5aFIiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZ3R5IjoicGFzc3dvcmQifQ.XwbY_-WOCBX4CiZ2MUNnTNEHY2FiQQG1FIt2ysDHgN6P7YjXdVeZUyTuzRgEKvqs1Uxp5HLtaLpYtiyoRpnPRmwEjBErQjBgke7GDvnMT9D4iRXT4bAFUjCUq8W5RIXk7vsMs91oMimGJcGu_YqHyGHnpfte7DflT0dqr-bP-48ON7pu0WBZHMb8KfwEmnzckYbVDtzo3EAvBHD2eMotgrdQo6t3XNfdz9TeEvs2yiOxhtv2OfUSffUBVJqSCwrxNVf_8OeWCLo98K4JmKecIpYKgzMBZ4E8-Xs-y1VthQdBHLp_NZ-NCpvrDAX3H9XOye0LQWxROFR9e4DvcMsG0A',
          'Content-Type': 'application/json',
          'Coordinates': jsonEncode(locationData)
        },
      );

      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print("fetched: ${responseData['posts']}");
        return responseData['posts'];
      } else {
        print("error: $responseData");
        final errorMessage =
            responseData['message'] as String? ?? 'Unknown error';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("error:: $e");
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> addPost(Map<String, dynamic> postData) {
    // TODO: implement addPost
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAllPost() async {
    final responseData = await _fetchData('getpost');
    print("Success");
    print("-----------========================== Fetched: " +
        responseData.toString());

    List<Post> articles = [];
    try {
      for (var blogData in responseData) {
        //      log(blogData.toString());
        articles.add(Post.fromJson(blogData));
      }
      return articles;
    } catch (e) {
      log("Error fetching posts: $e");
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<List<Post>> myPost() {
    // TODO: implement myPost
    throw UnimplementedError();
  }
}
