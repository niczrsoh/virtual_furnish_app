import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/firebaseStorageRepo.dart';

class UserRepo{

   static final CollectionReference _userCollection = FirebaseFirestore.instance.collection("User");
  //add new user using the user model
  static Future<String> saveUser( UserModel userModel) async {
    try{
      _userCollection.doc(userModel.id).set(userModel.toJson());
      return "User Added";
    }
    catch(e){
      return e.toString();
    }
  }

  //get user using the user id
  static Future<UserModel> getUser(String id) async {
    try{
    if(FirebaseAuth.instance.currentUser!.isAnonymous){
      return UserModel(id: FirebaseAuth.instance.currentUser!.uid, username: "Guest", email: "Guest", age: 0, profilePic: "", contact: "", status: "Guest");
    }else{
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);}}
    catch(e){
      throw e;
    }
  }
  //edit user profile
  static Future<String> editUser(UserModel userModel) async {
    try{
      if(userModel.profilePic!=null && !userModel.profilePic!.contains("https:/")){
      String url = await FirebaseStorageRepo.uploadFile(path: userModel.profilePic!, category: "Profile");
      userModel.profilePic = url;}
      String uid = AuthRepo.getCurrentUserId()!;
      print(userModel.toJson());
      Map updatedData = {
        "username": userModel.username,
        "email": userModel.email,
        "age": userModel.age,
        "profile_pic": userModel.profilePic,
        "contact": userModel.contact,
        "status": userModel.status
      };
      _userCollection.doc(uid).update(Map<String, dynamic>.from(updatedData));
      return "User Updated";
    }
    catch(e){
      return e.toString();
    }
  }

}