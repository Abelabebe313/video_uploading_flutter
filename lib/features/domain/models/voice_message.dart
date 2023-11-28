import 'dart:ui';

class VoiceMessageModel {
  int? id;
  late String name;
  late String date;
  late String content;
  late bool fromMe;
  late Color color;
  bool showTime = true;

  VoiceMessageModel(int id, String name, String content, bool fromMe,
      Color color, String date) {
    this.id = id;
    this.name = name;
    this.date = date;
    this.content = content;
    this.color = color;
    this.fromMe = fromMe;
  }

  VoiceMessageModel.time(int id, String name, String content, Color color,
      bool fromMe, bool showTime, String date) {
    this.id = id;
    this.name = name;
    this.date = date;
    this.content = content;
    this.fromMe = fromMe;
    this.color = color;
    this.showTime = showTime;
  }
}
