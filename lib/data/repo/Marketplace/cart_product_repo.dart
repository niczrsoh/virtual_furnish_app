
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

class CartProductRepo{
  static final userID =AuthRepo.getCurrentUserId()!;
  static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
  
  // Add product to cart
  static Future<String> addProductToCart(CartProductModel model) async {
    try{
      //create a new collection;
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      _cartCollection.doc().set(model.toJson());
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
    static Future<List<CartProductModel>> updateCartProduct(CartProductModel model){
    try{
      CollectionReference _cartCollection = _userCollection.doc(userID).collection("CartProduct");
      _cartCollection.doc().set(model.toJson());
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

}