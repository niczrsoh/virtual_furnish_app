// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MarketOrder {
  String? id;
  int? amount;
  String? courier;
  String? customerID;
  String? productID;
  String? status;
  String? transactionNumber;

  MarketOrder({this.id, this.amount, this.courier, this.customerID, this.productID, this.status, this.transactionNumber});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'courier': courier,
      'customerID': customerID,
      'productID': productID,
      'status': status,
      'transactionNumber': transactionNumber,
    };
  }

  factory MarketOrder.fromJson(Map<String, dynamic> map) {
    return MarketOrder(
      amount: map['amount'] != null ? map['amount'] as int : null,
      courier: map['courier'] != null ? map['courier'] as String : null,
      customerID: map['customerID'] != null ? map['customerID'] as String : null,
      productID: map['productID'] != null ? map['productID'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      transactionNumber: map['transactionNumber'] != null ? map['transactionNumber'] as String : null,
    );
  }

}
