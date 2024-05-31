import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';
import 'package:virtual_furnish_app/data/repo/firebaseStorageRepo.dart';

class SellerRepo{

   static final CollectionReference _sellerCollection = FirebaseFirestore.instance.collection("SellAccount");
   static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
     //to detrmine is user or seller
  static Future<String> isSeller(String id) async {
    try{
       DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      if(documentSnapshot.exists){
        return "user";
      }else{
        DocumentSnapshot sellerdocumentSnapshot = await _sellerCollection.doc(id).get();
        if(sellerdocumentSnapshot.exists){
          return "seller";
        }else{
          return "none";
        }
      }
    }
    catch(e){
      return e.toString();
    }
  }
  //add new user using the user model
  static Future<String> addSellRegister(SellerAccountModel sellerAccountModel) async {
    try{
      //get current user acc
      String uid = AuthRepo.getCurrentUserId()!;
      _sellerCollection.doc(sellerAccountModel.id).set(sellerAccountModel.toJson());
      _userCollection.doc(uid).update({"sell": sellerAccountModel.id});
      return "Seller Registered";
    }
    catch(e){  
      return e.toString();
    }
  }
  //get registered store 
  static Future<SellerAccountModel> getRegisteredShop() async {
    try{
      String userId = AuthRepo.getCurrentUserId()!;
      UserModel userModel = await UserRepo.getUser(userId);
      if(userModel.sell!.isEmpty) return SellerAccountModel();
      String sellId = userModel.sell!;
      DocumentSnapshot document = await _sellerCollection.doc(sellId).get();
      return document.exists ? SellerAccountModel.fromJson(document.data() as Map<String, dynamic>) : SellerAccountModel();
    }
    catch(e){
      throw e;
    }
  }
  //get user using the user id
  static Future<SellerAccountModel> getSellerInfo(String id) async {
    try{
      DocumentSnapshot documentSnapshot = await _sellerCollection.doc(id).get();
      SellerAccountModel model = SellerAccountModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      model.id = documentSnapshot.id;
      return model;
    }
    catch(e){
      throw e;
    }
  }
  //edit user profile
  static Future<String> editSeller(SellerAccountModel sellerAccountModel) async {
    try{
      // if(sellerAccountModel.profilePic!=null && !sellerAccountModel.profilePic!.contains("https:/")){
      // String url = await FirebaseStorageRepo.uploadFile(path: sellerAccountModel.profilePic!, category: "Profile");
      // sellerAccountModel.profilePic = url;}
      // String uid = AuthRepo.getCurrentUserId()!;
      // print(sellerAccountModel.toJson());
      // Map updatedData = {
      //   "username": sellerAccountModel.username,
      //   "email": sellerAccountModel.email,
      //   "age": sellerAccountModel.age,
      //   "profile_pic": sellerAccountModel.profilePic,
      //   "contact": sellerAccountModel.contact,
      //   "status": sellerAccountModel.status
      // };
      // _sellerCollection.doc(uid).update(Map<String, dynamic>.from(updatedData));
      return "User Updated";
    }
    catch(e){
      return e.toString();
    }
  }

}