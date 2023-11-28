import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploading/features/data/datasources/utils.dart';

import '../../domain/models/video.dart';

class VideoUpload extends StatefulWidget {
  const VideoUpload({Key? key}) : super(key: key);

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  String? _videoUrl;
  bool _uploading = false;
  VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Video')),
      body: Center(
        child: _uploading
            ? const Center(child: CircularProgressIndicator())
            : _videoUrl != null
                ? _videoPreviewWidget()
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
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
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
          ],
        );
      },
    );
  }

  void _pickVideo() async {
    _videoUrl = await pickVideo();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    if (_videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.file(File(_videoUrl!))
        ..initialize().then((_) {
          setState(() {
            _controller!.play();
          });
        });
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
        ElevatedButton(
          onPressed: _uploadVideo,
          child: const Text('Upload Video'),
        )
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

  void _uploadVideo() {
    print('Uploading Video: $_videoUrl');

    // Implement your video upload logic here
    // For simplicity, just simulate the upload process
    setState(() {
      _uploading = true;
    });

    // Simulate the upload process
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _uploading = false;
        _videoUrl = null; // Reset video URL after upload
      });
    });
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
