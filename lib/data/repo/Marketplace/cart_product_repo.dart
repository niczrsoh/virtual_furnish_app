
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

class CartProductRepo{
  static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");

  // Add product to cart
  static Future<String> addProductToCart(CartProductModel model) async {
    try{
      //create a new collection;
      //get list of carts
      List<CartProductModel> cartProducts = await getCartProducts();
      String userID = AuthRepo.getCurrentUserId()!;
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      String? cartID;
      int? prevAmount;
      //using loop to check 
      for(int i = 0; i < cartProducts.length; i++){
        if(cartProducts[i].productID == model.productID){
          cartID = cartProducts[i].id;
          prevAmount = cartProducts[i].amount;
          break;
        }
      }
      if(cartID!=null){
        int totalAmount = prevAmount! + model.amount!;
        _cartCollection.doc(cartID).update(
          {
            "amount": totalAmount
          }
        );
      }else{
      _cartCollection.doc().set(model.toJson());}
      // Add product to cart
      return "Cart Product Added";
    }
    catch(e){
      return e.toString();
    }
  }
  //get cart product
  static Future<List<CartProductModel>> getCartProducts(){
    try{
       String userID = AuthRepo.getCurrentUserId()!;
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      return _cartCollection.get().then((value) => value.docs.map((e) {
        CartProductModel model = CartProductModel.fromJson(e.data() as Map<String, dynamic>);
        model.id = e.id;
        return model;
      }).toList());
    }
    catch(e){
      throw e;
    }
  }
  //update quantity of product
    static Future<String> updateCartProduct(CartProductModel model) async{
    try{
       String userID = AuthRepo.getCurrentUserId()!;
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      await _cartCollection.doc(model.id).update(
        {
          "amount": model.amount,
          "priority": model.priority
        }
      );
      return "Successfully Updated";
    }
    catch(e){
      throw e;
    }
  }
  //remove product from cart
  static Future<String> removeProductFromCart(CartProductModel model) async{
    try{
       String userID = AuthRepo.getCurrentUserId()!;
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      //assert if only the product id is present
      assert(model.id!=null);
      await _cartCollection.doc(model.id).delete();
      return "Successfully Removed";
    }
    catch(e){
      throw e;
    }
  }

  //get a single cart product
  static Future<CartProductModel> getCartProduct(String id) async{
    try{
       String userID = AuthRepo.getCurrentUserId()!;
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      return _cartCollection.doc(id).get().then((value) {
        CartProductModel model = CartProductModel.fromJson(value.data() as Map<String, dynamic>);
        model.id = value.id;
        return model;
      });
    }
    catch(e){
      throw e;
    }
  }
}