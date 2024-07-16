

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/checkout_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

class CheckoutPaymentRepo{
static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
/*
nicShop{
  product1{"amount"},
  product2{"amount"}
}
{product1,product2}
 */
  //seperate each products by seller name
static Future<List<CheckoutModel>> mapProductsToSellers(List<CartProductModel> cartProducts) async {
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

//get list of address
static Future<List<String>> getAddress() async {
  List<String> address = [];
  try {
    String id = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> addressList = await UserRepo.getUser(id).then((value) => value.deliveredAddress??[]);
    address = addressList.map((e) => e.toString()).toList();
    return address;
  }catch(e){
    throw e;
  }
}
//add address
static Future<String> addAddress(String address) async {
  try {
    String id = FirebaseAuth.instance.currentUser!.uid;
    List<String> addressList = await getAddress();
    addressList.add(address);
      Map updatedData = {
        "delivered_address": addressList 
      };
    //update user model
     _userCollection.doc(id).update(Map<String, dynamic>.from(updatedData));
    return "Address Added";
  }catch(e){
    throw e;
  }
}
//change address sequence
static Future<String> changeAddress(String address) async {
  try {
    String id = FirebaseAuth.instance.currentUser!.uid;
    List<String> addressList = await getAddress();
    addressList.remove(address);
    addressList.insert(0, address);
    Map updatedData = {
        "delivered_address": addressList 
      };
    //update user model
     _userCollection.doc(id).update(Map<String, dynamic>.from(updatedData));
    return "Address Changed";
  }catch(e){
    throw e;
  }
}
//remove address
static void removeAddress(String address) {
  String id = FirebaseAuth.instance.currentUser!.uid;
  _userCollection.doc(id).update({
    "delivered_address": FieldValue.arrayRemove([address])
  });}

}