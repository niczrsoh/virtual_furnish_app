

import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/checkout_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

class CheckoutPaymentRepo{

/*
nicShop{
  product1{"amount"},
  product2{"amount"}
}
{product1,product2}
 */
  //seperate each products by seller name
Future<List<CheckoutModel>> mapProductsToSellers(List<CartProductModel> cartProducts) async {
  List<CheckoutModel> checkoutProducts = [];
  //change the amount to cart amount
  for (CartProductModel cartProduct in cartProducts) {
    //get product details by product id
    MarketplaceProductModel product = await MarketplaceRepo.getSellingItem(cartProduct.productID!);
    String sellerID = product.sellerID!;
    //find seller name from seller id
    SellerAccountModel sellerModel = await SellerRepo.getSellerInfo(sellerID);
    String sellerName = sellerModel.shopName!;
    if (checkoutProducts.isEmpty) {
      checkoutProducts.add(CheckoutModel(sellerName: sellerName, sellerProducts: [{product: cartProduct.amount!}], totalPayment: product.price! * cartProduct.amount!));
    } else {
      //find the index of the seller
      int index = checkoutProducts.indexWhere((element) => element.sellerName!.compareTo(sellerName) == 0);
      if (index == -1) {
        checkoutProducts.add(CheckoutModel(sellerName: sellerName, sellerProducts: [{product: cartProduct.amount!}], totalPayment: product.price! * cartProduct.amount!));
      }else{
      //add the product to the seller
      checkoutProducts[index].sellerProducts!.add({product: cartProduct.amount!});
      //add the total payment
      checkoutProducts[index].totalPayment = checkoutProducts[index].totalPayment! + (product.price! * cartProduct.amount!);}
    }
  }
  return checkoutProducts;
}

}