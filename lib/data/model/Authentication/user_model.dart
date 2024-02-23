class UserModel {
  String? id;
  String? username;
  String? email;
  String? profilePic;
  String? sell;
  List<Map<String, dynamic>>? deliveredAddress;
  String? contact;
  String? status;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.profilePic,
    this.sell,
    this.deliveredAddress,
    this.contact,
    this.status,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profilePic = json['profile_pic'];
    sell = json['sell'];
    deliveredAddress = json['delivered_address'];
    contact = json['contact'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['profile_pic'] = profilePic;
    data['sell'] = sell;
    data['delivered_address'] = deliveredAddress;
    data['contact'] = contact;
    data['status'] = status;
    return data;
  }
}
