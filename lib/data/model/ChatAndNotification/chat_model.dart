class ChatModel {
  String? id;
  String? priority;
  String? opponentID;

  ChatModel(
      {this.id,
      this.priority,
      this.opponentID});
  
  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    priority = json['priority'];
    opponentID = json['opponentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['priority'] = priority;
    data['opponentID'] = opponentID;
    return data;
  }
}
