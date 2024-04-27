class OrderStatus{
  String? id;
  int? amount;
  String? status;
  String? trackingNumber;
  String? latestTransaction;
  String? productID;
  String? from;

  OrderStatus({this.id, this.amount, this.status, this.trackingNumber, this.latestTransaction, this.productID, this.from});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'status': status,
      'trackingNumber': trackingNumber,
      'latestTransaction': latestTransaction,
      'productID': productID,
      'from': from,
    };
  }

  factory OrderStatus.fromJson(Map<String, dynamic> map) {
    return OrderStatus(
      amount: map['amount'] != null ? map['amount'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      trackingNumber: map['trackingNumber'] != null ? map['trackingNumber'] as String : null,
      latestTransaction: map['latestTransaction'] != null ? map['latestTransaction'] as String : null,
      productID: map['productID'] != null ? map['productID'] as String : null,
      from: map['from'] != null ? map['from'] as String : null,
    );
  }
}