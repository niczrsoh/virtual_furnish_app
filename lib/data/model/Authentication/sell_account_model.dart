class SellerAccountModel {
  String? id;
  String? nricFile;
  String? ssmFile;
  String? bankDoc;
  String? email;
  String? location;
  String? shopName;
  String? type;
  String? userID;
  String? profilePic;
  SellerAccountModel(
      {
        this.id,
        this.nricFile,
      this.ssmFile,
      this.bankDoc,
      this.email,
      this.location,
      this.shopName,
      this.type,
      this.userID,
      this.profilePic
      });
  
  SellerAccountModel.fromJson(Map<String, dynamic> json) {
    nricFile = json['NRICfile'];
    ssmFile = json['SSMfile'];
    bankDoc = json['bankDoc'];
    email = json['email'];
    location = json['location'];
    shopName = json['shopName'];
    type = json['type'];
    userID = json['userID'];
    profilePic = json['profilePic'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NRICfile'] = nricFile;
    data['SSMfile'] = ssmFile;
    data['bankDoc'] = bankDoc;
    data['email'] = email;
    data['location'] = location;
    data['shopName'] = shopName;
    data['type'] = type;
    data['userID'] = userID;
    data['profilePic'] = profilePic;
    return data;
  }
}
