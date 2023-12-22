import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploading/features/data/datasources/remote_data_source.dart';
import 'package:video_uploading/features/data/datasources/utils.dart';

import '../../domain/models/video.dart';

class VideoUpload extends StatefulWidget {
  const VideoUpload({Key? key}) : super(key: key);

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  String? _audioUrl;
  String? _videoUrl;
  String? _imageUrl;
  bool _uploading = false;
  VideoPlayerController? _controller;
  final remoteDataSource = RemoteDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Video')),
      body: Center(
        child: _uploading
            ? const Center(child: CircularProgressIndicator())
            : _videoUrl != null
                ? _videoPreviewWidget()
                : _imageUrl != null
                    ? _imagePreviewWidget()
                    : _audioUrl != null
                        ? _audioPreviewWidget()
                        : _cameraWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show options for picking or recording a video
          _showOptions();
        },
        child: const Icon(Icons.video_library),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _showOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.audiotrack),
              title: const Text('Audio Pick'),
              onTap: () {
                Navigator.pop(context);
                _pickAudio();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Pick Image'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Pick Video'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickAudio() async {
    _audioUrl = await pickAudio();
    setState(() {});
  }

  void _pickVideo() async {
    _videoUrl = await pickVideo();
    _initializeVideoPlayer();
  }

  void _pickImage() async {
    _imageUrl = await pickImage();
    setState(() {});
  }

  void _initializeVideoPlayer() {
    if (_videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.file(File(_videoUrl!))
        ..initialize().then(
          (_) {
            setState(() {
              _controller!.play();
            });
          },
        );
    }
  }

  Widget _cameraWidget() {
    return FlutterCamera(
      onVideoRecorded: (value) {
        final path = value.path;
        print('Recorded Video Path: $path');
        setState(() {
          _videoUrl = path;
        });
      },
      color: Colors.grey,
    );
  }

  Widget _audioPreviewWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _audioUrl != null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 10),
                      Text('Audio file selected'),
                    ],
                  ),
                )
              : Container(),
          
          ElevatedButton.icon(
            onPressed: () async {
              // Show progress dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Uploading..."),
                      ],
                    ),
                  );
                },
              );
    
              // Simulate upload progress for 5 seconds
              await Future.delayed(Duration(seconds: 5));
    
              // Hide progress dialog
              Navigator.pop(context);
    
              // Call your upload function
              _uploadAudio();
            },
            icon: Icon(Icons.upload_outlined),
            label: Text('Upload Audio'),
          ),
        ],
      ),
    );
  }

  Widget _imagePreviewWidget() {
    return Column(
      children: [
        _imageUrl != null
            ? Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(_imageUrl!)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Container(),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            // Show progress dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Uploading..."),
                    ],
                  ),
                );
              },
            );

            // Simulate upload progress for 5 seconds
            await Future.delayed(Duration(seconds: 5));

            // Hide progress dialog
            Navigator.pop(context);

            // Call your upload function
            _uploadImage();
          },
          icon: Icon(Icons.upload_outlined),
          label: Text('Upload Image'),
        ),
      ],
    );
  }

  Widget _videoPreviewWidget() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            // Show progress dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Uploading..."),
                    ],
                  ),
                );
              },
            );

            // Simulate upload progress for 5 seconds
            await Future.delayed(Duration(seconds: 5));

            // Hide progress dialog
            Navigator.pop(context);

            // Call your upload function
            _uploadVideo();
          },
          icon: Icon(Icons.upload_outlined),
          label: Text('Upload Video'),
        ),
      ],
    );
  }

  Future<void> _recordVideo() async {
    // Navigate to the camera widget and wait for the result
    final recordedVideoPath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );

    // If a video is recorded, update the state with the video path
    if (recordedVideoPath != null) {
      setState(() {
        _videoUrl = recordedVideoPath;
      });
    }
  }

  void _uploadAudio() async {
    print('Uploading Audio: ====>$_audioUrl<====');

    // Implement your video upload logic here
    // For simplicity, just simulate the upload process
    setState(() {
      _uploading = true;
    });

    // Simulate the upload process
    try {
      if (_audioUrl != null) {
        // Assuming you have the video data in _videoUrl
        Map<dynamic, dynamic> postData = {
          'text': 'Audio post from mobile',
          'audio': _audioUrl,
          // Add other necessary data if needed
        };

        // Call the addPost function
        Map<dynamic, dynamic> result =
            await remoteDataSource.audioPost(postData);

        if (result['status'] == 'success') {
          print('========>>>>>Audio uploaded successfully<<<<==========');
          // Do something on success, if needed
        } else {
          print(
              '========>>>>>Failed to upload Audio: ${result['message']}<<<<==========');
          // Handle error, if needed
        }
      }
    } catch (e) {
      print('========>>>>>Error uploading video: $e<<<<==========');
      // Handle error, if needed
    } finally {
      setState(() {
        _uploading = false;
        _imageUrl = null; // Reset image URL after upload
      });
    }
  }

  void _uploadImage() async {
    print('Uploading Image: ====>$_imageUrl<====');

    // Implement your video upload logic here
    // For simplicity, just simulate the upload process
    setState(() {
      _uploading = true;
    });

    // Simulate the upload process
    try {
      if (_imageUrl != null) {
        // Assuming you have the video data in _videoUrl
        Map<dynamic, dynamic> postData = {
          'text': 'Image post from mobile',
          'image': _imageUrl,
          // Add other necessary data if needed
        };

        // Call the addPost function
        Map<dynamic, dynamic> result =
            await remoteDataSource.imagePost(postData);

        if (result['status'] == 'success') {
          print('========>>>>>Image uploaded successfully<<<<==========');
          // Do something on success, if needed
        } else {
          print(
              '========>>>>>Failed to upload video: ${result['message']}<<<<==========');
          // Handle error, if needed
        }
      }
    } catch (e) {
      print('========>>>>>Error uploading video: $e<<<<==========');
      // Handle error, if needed
    } finally {
      setState(() {
        _uploading = false;
        _imageUrl = null; // Reset image URL after upload
      });
    }
  }

  void _uploadVideo() async {
    print('Uploading Video: $_videoUrl');

    // Implement your video upload logic here
    // For simplicity, just simulate the upload process
    setState(() {
      _uploading = true;
    });

    // Simulate the upload process
    try {
      if (_videoUrl != null) {
        // Assuming you have the video data in _videoUrl
        Map<dynamic, dynamic> postData = {
          'text': 'Video post from mobile',
          'video': _videoUrl,
          // Add other necessary data if needed
        };

        // Call the addPost function
        Map<dynamic, dynamic> result =
            await remoteDataSource.videoPost(postData);

        if (result['status'] == 'success') {
          print('========>>>>>Video uploaded successfully<<<<==========');
          // Do something on success, if needed
        } else {
          print(
              '========>>>>>Failed to upload video: ${result['message']}<<<<==========');
          // Handle error, if needed
        }
      }
    } catch (e) {
      print('========>>>>>Error uploading video: $e<<<<==========');
      // Handle error, if needed
    } finally {
      setState(() {
        _uploading = false;
        _videoUrl = null; // Reset video URL after upload
      });
    }
  }
}

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterCamera(
      onVideoRecorded: (value) {
        final path = value.path;
        print("Recorded Video Path: $path");
        Navigator.pop(context, path); // Return the recorded video path
      },
      color: Colors.grey,
    );
  }
}
