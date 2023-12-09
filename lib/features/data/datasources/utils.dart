import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

pickVideo() async {
  final picker = ImagePicker();
  XFile? videoFile;
  try{
    videoFile = await picker.pickVideo(source: ImageSource.gallery);
    return videoFile!.path;
  } catch (e) {
    print('Error While picking video: $e');
  }
}


Future<String?> pickAudio() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      String audioPath = result.files.first.path!;
      return audioPath;
    } else {
      return null; // User canceled the file picking
    }
  } catch (e) {
    print('Error While picking audio: $e');
    return null;
  }
}


pickImage() async {
  final picker = ImagePicker();
  XFile? ImageFile;
  try{
    ImageFile = await picker.pickImage(source: ImageSource.gallery);
    return ImageFile!.path;
  } catch (e) {
    print('Error While picking video: $e');
  }
}
