// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemListModel{
  ItemList? output;
  //Meta meta; // if you have meta from api response then you can add meta
 ItemListModel({this.output});
  ItemListModel.fromJson(Map<String, dynamic> json) {
      output = json['output'] != null ? ItemList.fromJson(json['output']) : null;
    }

}

class ItemList {
  List<ItemDetails>? items;
  int? totalCount;
  int? pageSize;
  ItemList({
    this.items,
    this.totalCount,
    this.pageSize,
  });
  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => ItemDetails.fromJson(i))
              .toList()
          : null,
      totalCount: json['totalCount'],
      pageSize: json['pageSize'],
    );
  }
}

class ItemDetails{
  String? itemName;
  double? itemPrice;
  String? itemImage;
  String? itemDescription;
  ItemDetails({
    this.itemName,
    this.itemPrice,
    this.itemImage,
    this.itemDescription,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
      itemImage: json['itemImage'],
      itemDescription: json['itemDescription'],
    );
  }
  Map toJson() => {
    'itemName': itemName,
    'itemPrice': itemPrice,
    'itemImage': itemImage,
    'itemDescription': itemDescription,
  };
}