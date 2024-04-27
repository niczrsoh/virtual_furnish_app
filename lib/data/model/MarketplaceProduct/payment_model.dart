class PaymentModel{
  String? id;
  String? account;
  int? amount;
  String? cartID;
  String? method;

  PaymentModel({this.id, this.account, this.amount, this.cartID, this.method});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      account: json['account'],
      amount: json['amount'],
      cartID: json['cartID'],
      method: json['method']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'amount': amount,
      'cartID': cartID,
      'method': method
    };
  }
}