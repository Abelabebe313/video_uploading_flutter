class Post {
  int? id;
  String? createdAt;
  String? textContent;
  List<String>? imageContents;
  List<String>? audioContents;
  List<String>? videoContents;
  Location? location;
  int? relevance;
  String? views;
  String? postPrivacy;
  String? commentPrivacy;
  String? reactionPrivacy;

  Post(
      {this.id,
      this.createdAt,
      this.textContent,
      this.imageContents,
      this.audioContents,
      this.videoContents,
      this.location,
      this.relevance,
      this.views,
      this.postPrivacy,
      this.commentPrivacy,
      this.reactionPrivacy});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    textContent = json['textContent'];
    imageContents = json['imageContents'].cast<String>();
    audioContents = json['audioContents'].cast<String>();
    videoContents = json['videoContents'].cast<String>();
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    relevance = json['relevance'];
    views = json['views'];
    postPrivacy = json['postPrivacy'];
    commentPrivacy = json['commentPrivacy'];
    reactionPrivacy = json['reactionPrivacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['textContent'] = this.textContent;
    if (this.imageContents != null) {
      data['imageContents'] = this.imageContents;
    }
    if (this.audioContents != null) {
      data['audioContents'] = this.audioContents;
    }
    if (this.videoContents != null) {
      data['videoContents'] = this.videoContents;
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['relevance'] = this.relevance;
    data['views'] = this.views;
    data['postPrivacy'] = this.postPrivacy;
    data['commentPrivacy'] = this.commentPrivacy;
    data['reactionPrivacy'] = this.reactionPrivacy;
    return data;
  }
}

class Location {
  String? longitude;
  String? latitude;

  Location({this.longitude, this.latitude});

  Location.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
