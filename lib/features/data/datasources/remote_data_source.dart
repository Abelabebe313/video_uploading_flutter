import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:video_uploading/features/data/models/post.dart';
import 'package:http/http.dart' as http;
import 'data_source_api.dart';
import 'package:dio/dio.dart';

class RemoteDataSource implements PostRemoteDataSource {
  RemoteDataSource();
  Dio dio = Dio();

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
  Future<Map<dynamic, dynamic>> audioPost(
      Map<dynamic, dynamic> postData) async {
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
      print('============|> now its on addPost method <|============');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.redwolfsoft.com/api/post'),
      );
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNKWmFvVDBYWnFkb1BKMnpOWlJ4UyJ9.eyJpc3MiOiJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2NTYyNGI5ZjE3YjRiZGI1MDExMzUxZDgiLCJhdWQiOlsiaHR0cHM6Ly9ha2FiYWJpLWFwaS5jb20iLCJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3MDA5NDA3NTAsImV4cCI6MTcwMzIyNzE0OCwiYXpwIjoiVnFmVkdYSlNUWXdQMkZJa2RkWFYxMDZiMkJyRXF5aFIiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZ3R5IjoicGFzc3dvcmQifQ.XwbY_-WOCBX4CiZ2MUNnTNEHY2FiQQG1FIt2ysDHgN6P7YjXdVeZUyTuzRgEKvqs1Uxp5HLtaLpYtiyoRpnPRmwEjBErQjBgke7GDvnMT9D4iRXT4bAFUjCUq8W5RIXk7vsMs91oMimGJcGu_YqHyGHnpfte7DflT0dqr-bP-48ON7pu0WBZHMb8KfwEmnzckYbVDtzo3EAvBHD2eMotgrdQo6t3XNfdz9TeEvs2yiOxhtv2OfUSffUBVJqSCwrxNVf_8OeWCLo98K4JmKecIpYKgzMBZ4E8-Xs-y1VthQdBHLp_NZ-NCpvrDAX3H9XOye0LQWxROFR9e4DvcMsG0A';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Coordinates'] = jsonEncode(locationData);

      request.fields['text'] = postData['text'];
      var audioFile =
          await http.MultipartFile.fromPath('audio', postData['audio']);
      request.files.add(audioFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return {
          'status': 'success',
          'message':
              '======**********Audio Post added successfully********========'
        };
      } else {
        print(response.reasonPhrase);
        return {'status': 'error', 'message': 'Failed to add post'};
      }
    } catch (e) {
      print('Error: $e');
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }

  @override
  Future<Map<dynamic, dynamic>> videoPost(
      Map<dynamic, dynamic> postData) async {
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
      print('============|> now its on addPost method <|============');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.redwolfsoft.com/api/post'),
      );
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNKWmFvVDBYWnFkb1BKMnpOWlJ4UyJ9.eyJpc3MiOiJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2NTYyNGI5ZjE3YjRiZGI1MDExMzUxZDgiLCJhdWQiOlsiaHR0cHM6Ly9ha2FiYWJpLWFwaS5jb20iLCJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3MDA5NDA3NTAsImV4cCI6MTcwMzIyNzE0OCwiYXpwIjoiVnFmVkdYSlNUWXdQMkZJa2RkWFYxMDZiMkJyRXF5aFIiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZ3R5IjoicGFzc3dvcmQifQ.XwbY_-WOCBX4CiZ2MUNnTNEHY2FiQQG1FIt2ysDHgN6P7YjXdVeZUyTuzRgEKvqs1Uxp5HLtaLpYtiyoRpnPRmwEjBErQjBgke7GDvnMT9D4iRXT4bAFUjCUq8W5RIXk7vsMs91oMimGJcGu_YqHyGHnpfte7DflT0dqr-bP-48ON7pu0WBZHMb8KfwEmnzckYbVDtzo3EAvBHD2eMotgrdQo6t3XNfdz9TeEvs2yiOxhtv2OfUSffUBVJqSCwrxNVf_8OeWCLo98K4JmKecIpYKgzMBZ4E8-Xs-y1VthQdBHLp_NZ-NCpvrDAX3H9XOye0LQWxROFR9e4DvcMsG0A';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Coordinates'] = jsonEncode(locationData);

      request.fields['text'] = postData['text'];
      var videoFile =
          await http.MultipartFile.fromPath('video', postData['video']);
      request.files.add(videoFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return {
          'status': 'success',
          'message': '======**********Post added successfully********========'
        };
      } else {
        print(response.reasonPhrase);
        return {'status': 'error', 'message': 'Failed to add post'};
      }
    } catch (e) {
      print('Error: $e');
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }

  @override
  Future<Map<dynamic, dynamic>> imagePost(
      Map<dynamic, dynamic> postData) async {
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
      print('============|> now its on addPost method <|============');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.redwolfsoft.com/api/post'),
      );
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNKWmFvVDBYWnFkb1BKMnpOWlJ4UyJ9.eyJpc3MiOiJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2NTYyNGI5ZjE3YjRiZGI1MDExMzUxZDgiLCJhdWQiOlsiaHR0cHM6Ly9ha2FiYWJpLWFwaS5jb20iLCJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3MDA5NDA3NTAsImV4cCI6MTcwMzIyNzE0OCwiYXpwIjoiVnFmVkdYSlNUWXdQMkZJa2RkWFYxMDZiMkJyRXF5aFIiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZ3R5IjoicGFzc3dvcmQifQ.XwbY_-WOCBX4CiZ2MUNnTNEHY2FiQQG1FIt2ysDHgN6P7YjXdVeZUyTuzRgEKvqs1Uxp5HLtaLpYtiyoRpnPRmwEjBErQjBgke7GDvnMT9D4iRXT4bAFUjCUq8W5RIXk7vsMs91oMimGJcGu_YqHyGHnpfte7DflT0dqr-bP-48ON7pu0WBZHMb8KfwEmnzckYbVDtzo3EAvBHD2eMotgrdQo6t3XNfdz9TeEvs2yiOxhtv2OfUSffUBVJqSCwrxNVf_8OeWCLo98K4JmKecIpYKgzMBZ4E8-Xs-y1VthQdBHLp_NZ-NCpvrDAX3H9XOye0LQWxROFR9e4DvcMsG0A';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Coordinates'] = jsonEncode(locationData);

      request.fields['text'] = postData['text'];
      var imageFile =
          await http.MultipartFile.fromPath('image', postData['image']);
      request.files.add(imageFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return {
          'status': 'success',
          'message': '======**********Post added successfully********========'
        };
      } else {
        print(response.reasonPhrase);
        return {'status': 'error', 'message': 'Failed to add post'};
      }
    } catch (e) {
      print('Error: $e');
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }

  @override
  Future<Map<dynamic, dynamic>> commentPost(
      Map<dynamic, dynamic> commentData) async {
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
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.redwolfsoft.com/api/post/comment?post_id=${commentData['post_id']}'),
      );
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNKWmFvVDBYWnFkb1BKMnpOWlJ4UyJ9.eyJpc3MiOiJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2NTYyNGI5ZjE3YjRiZGI1MDExMzUxZDgiLCJhdWQiOlsiaHR0cHM6Ly9ha2FiYWJpLWFwaS5jb20iLCJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3MDA5NDA3NTAsImV4cCI6MTcwMzIyNzE0OCwiYXpwIjoiVnFmVkdYSlNUWXdQMkZJa2RkWFYxMDZiMkJyRXF5aFIiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZ3R5IjoicGFzc3dvcmQifQ.XwbY_-WOCBX4CiZ2MUNnTNEHY2FiQQG1FIt2ysDHgN6P7YjXdVeZUyTuzRgEKvqs1Uxp5HLtaLpYtiyoRpnPRmwEjBErQjBgke7GDvnMT9D4iRXT4bAFUjCUq8W5RIXk7vsMs91oMimGJcGu_YqHyGHnpfte7DflT0dqr-bP-48ON7pu0WBZHMb8KfwEmnzckYbVDtzo3EAvBHD2eMotgrdQo6t3XNfdz9TeEvs2yiOxhtv2OfUSffUBVJqSCwrxNVf_8OeWCLo98K4JmKecIpYKgzMBZ4E8-Xs-y1VthQdBHLp_NZ-NCpvrDAX3H9XOye0LQWxROFR9e4DvcMsG0A';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Coordinates'] = jsonEncode(locationData);

      request.fields['text'] = commentData['text'];

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return {
          'status': 'success',
          'message':
              '======**********Comment added successfully********========'
        };
      } else {
        print(response.reasonPhrase);
        return {'status': 'error', 'message': 'Failed to add Comment'};
      }
    } catch (e) {
      print('Error: $e');
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }

  @override
  Future<Map<dynamic, dynamic>> reactPost(
      Map<dynamic, dynamic> reactionData) async {
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
      print('============|> now its on react post method <|============');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.redwolfsoft.com/api/post/reaction'),
      );
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNKWmFvVDBYWnFkb1BKMnpOWlJ4UyJ9.eyJpc3MiOiJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2NTYyNGI5ZjE3YjRiZGI1MDExMzUxZDgiLCJhdWQiOlsiaHR0cHM6Ly9ha2FiYWJpLWFwaS5jb20iLCJodHRwczovL3JlZHdvbGZzb2Z0LnVzLmF1dGgwLmNvbS91c2VyaW5mbyJdLCJpYXQiOjE3MDA5NDA3NTAsImV4cCI6MTcwMzIyNzE0OCwiYXpwIjoiVnFmVkdYSlNUWXdQMkZJa2RkWFYxMDZiMkJyRXF5aFIiLCJzY29wZSI6Im9wZW5pZCBwcm9maWxlIGVtYWlsIiwiZ3R5IjoicGFzc3dvcmQifQ.XwbY_-WOCBX4CiZ2MUNnTNEHY2FiQQG1FIt2ysDHgN6P7YjXdVeZUyTuzRgEKvqs1Uxp5HLtaLpYtiyoRpnPRmwEjBErQjBgke7GDvnMT9D4iRXT4bAFUjCUq8W5RIXk7vsMs91oMimGJcGu_YqHyGHnpfte7DflT0dqr-bP-48ON7pu0WBZHMb8KfwEmnzckYbVDtzo3EAvBHD2eMotgrdQo6t3XNfdz9TeEvs2yiOxhtv2OfUSffUBVJqSCwrxNVf_8OeWCLo98K4JmKecIpYKgzMBZ4E8-Xs-y1VthQdBHLp_NZ-NCpvrDAX3H9XOye0LQWxROFR9e4DvcMsG0A';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Coordinates'] = jsonEncode(locationData);

      request.fields['post_id'] = reactionData['post_id'];
      request.fields['reaction_id'] = reactionData['reaction_id'];

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return {
          'status': 'success',
          'message': '======**********react added successfully********========'
        };
      } else {
        print(response.reasonPhrase);
        return {'status': 'error', 'message': 'Failed to add React'};
      }
    } catch (e) {
      print('Error: $e');
      return {'status': 'error', 'message': 'An error occurred'};
    }
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
