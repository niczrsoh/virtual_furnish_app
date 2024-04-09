class CartProductModel {
  String? id;
  String? priority;
  int? amount;
  String? productID;

  CartProductModel(
      {this.id,
      this.priority,
      this.amount,
      this.productID});
  
  CartProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    priority = json['priority'];
    amount = json['amount'];
    productID = json['productID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['priority'] = priority;
    data['productID'] = productID;
    return data;
  }
}
