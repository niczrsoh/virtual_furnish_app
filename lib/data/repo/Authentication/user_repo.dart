import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';

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
}