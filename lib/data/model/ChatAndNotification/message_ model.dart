import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? id;
  Timestamp? time;
  String? sentBy;
  String? textMessage;
  bool? checked;
  MessageModel(
      {this.id,
      this.time,
      this.sentBy,
      this.textMessage,
      this.checked });
  
  MessageModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    sentBy = json['sentBy'];
    textMessage = json['textMessage'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sentBy'] = sentBy;
    data['time'] = time;
    data['textMessage'] = textMessage;
    data['checked'] = checked;
    return data;
  }
}
