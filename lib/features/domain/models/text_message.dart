class TextMessage {
  int? id;
  late String date;
  late String content;
  late bool fromMe;
  bool showTime = true;

  TextMessage(int id, String content, bool fromMe, String date) {
    this.id = id;
    this.date = date;
    this.content = content;
    this.fromMe = fromMe;
  }

  TextMessage.time(
      int id, String content, bool fromMe, bool showTime, String date) {
    this.id = id;
    this.date = date;
    this.content = content;
    this.fromMe = fromMe;
    this.showTime = showTime;
  }
}
