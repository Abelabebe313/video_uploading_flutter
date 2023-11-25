import 'dart:io';

import 'package:flutter/material.dart';
import '../service/utils.dart';
import '../service/save_video.dart';
import 'package:video_player/video_player.dart';
import 'package:video_uploading/models/video.dart';

class VideoUpload extends StatefulWidget {
  const VideoUpload({super.key});

  @override
  State<VideoUpload> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  List<Video> videoData = [];
  String? _videoUrl;
  VideoPlayerController? _controller;
  String? _downloadUrl;
  bool _uploading = false;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Uploader')),
      body: Center(
        child: _uploading
            ? Center(child: CircularProgressIndicator())
            : _videoUrl != null
                ? _videoPreviewWidget()
                : const Text('No video selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        child: const Icon(Icons.video_library),
      ),
    );
  }

  void _pickVideo() async {
    _videoUrl = await pickVideo();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoUrl!))
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
  }

  Widget _videoPreviewWidget() {
    if (_controller != null) {
      return Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _uploadVideo,
            child: Text('Upload Video'),
          )
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  void _uploadVideo() async {
    setState(() {
      _uploading = true;
    });
    _downloadUrl = await StoreData().uploadVideo(_videoUrl!);
    await StoreData().saveVideoData(_downloadUrl!);
    setState(() {
      _videoUrl = null;
      _uploading = false;
    });
  }
}
