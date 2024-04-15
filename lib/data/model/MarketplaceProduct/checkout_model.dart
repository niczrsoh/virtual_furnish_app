import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';


//one model will have the seller name and the products 
class CheckoutModel{
  String? sellerName;
  List<Map<MarketplaceProductModel,int>>? sellerProducts;
  double? totalPayment;
  String? voucherCode;
  CheckoutModel({this.sellerName, this.sellerProducts, this.totalPayment, this.voucherCode});
}