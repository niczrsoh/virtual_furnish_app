class MarketplaceProductModel {
  String? id;
  String? threeDimensionModel;
  String? category;
  int? amount;
  int? buyers;
  String? description;
  String? location;
  List<dynamic>? images;
  String? name;
  String? sellerID;
  String? video;
  double? price;

  MarketplaceProductModel(
      {this.id,
      this.threeDimensionModel,
      this.category,
      this.amount,
      this.buyers,
      this.description,
      this.location,
      this.images,
      this.name,
      this.sellerID,
      this.video,
      this.price});
  
  MarketplaceProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    threeDimensionModel = json['3DModel'];
    category = json['category'];
    amount = json['amount'];
    buyers = json['buyers'];
    description = json['description'];
    location = json['location'];
    images = json['2dImages'];
    name = json['name'];
    sellerID = json['sellerID'];
    video = json['video'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['3DModel'] = threeDimensionModel;
    data['category'] = category;
    data['amount'] = amount;
    data['buyers'] = buyers;
    data['description'] = description;
    data['location'] = location;
    data['2dImages'] = images;
    data['name'] = name;
    data['sellerID'] = sellerID;
    data['video'] = video;
    data['price'] = price;
    return data;
  }
}
