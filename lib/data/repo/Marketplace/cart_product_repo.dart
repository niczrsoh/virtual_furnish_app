
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
      //get list of carts
      List<CartProductModel> cartProducts = await getCartProducts();
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
  
}