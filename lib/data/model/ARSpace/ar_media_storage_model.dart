import 'package:cloud_firestore/cloud_firestore.dart';

class ARMediaStorageModel {
  String? id;
  String? video;
  String? image;
  Timestamp? time;
  String? category;
  ARMediaStorageModel(
      {
      this.id,
        this.video,
      this.image,
      this.time,
      this.category
      });

  ARMediaStorageModel.fromJson(Map<String, dynamic> json) {
    video = json['video'];
    image = json['image'];
    time = json['time'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video'] = video;
    data['image'] = image;
    data['time'] = time;
    data['category'] = category;
    return data;
  }
}
