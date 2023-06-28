class Ordinal {
  int? id;
  int? userId;
  String? imageId;
  String? inscription;

  Ordinal({this.id, this.userId, this.imageId, this.inscription});

  Ordinal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    imageId = json['imageId'];
    inscription = json['inscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['imageId'] = imageId;
    data['inscription'] = inscription;
    return data;
  }
}