class Post {
  int? id;
  String? createdAt;
  String? textContent;
  List<dynamic>? imageContents;
  List<dynamic>? audioContents;
  List<String>? videoContents;
  Location? location;
  int? relevance;
  String? views;
  String? postPrivacy;
  String? commentPrivacy;
  String? reactionPrivacy;

  Post({
    this.id,
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
    this.reactionPrivacy,
  });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    textContent = json['textContent'];
    if (json['imageContents'] != null) {
      imageContents = <dynamic>[];
      json['imageContents'].forEach((v) {
        imageContents!.add(v);
      });
    }
    if (json['audioContents'] != null) {
      audioContents = <dynamic>[];
      json['audioContents'].forEach((v) {
        audioContents!.add(v);
      });
    }
    videoContents = json['videoContents']?.cast<String>();
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    relevance = json['relevance'];
    views = json['views'];
    postPrivacy = json['postPrivacy'];
    commentPrivacy = json['commentPrivacy'];
    reactionPrivacy = json['reactionPrivacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['textContent'] = textContent;
    if (imageContents != null) {
      data['imageContents'] = imageContents;
    }
    if (audioContents != null) {
      data['audioContents'] = audioContents;
    }
    data['videoContents'] = videoContents;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['relevance'] = relevance;
    data['views'] = views;
    data['postPrivacy'] = postPrivacy;
    data['commentPrivacy'] = commentPrivacy;
    data['reactionPrivacy'] = reactionPrivacy;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
