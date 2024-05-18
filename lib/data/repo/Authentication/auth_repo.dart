import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:virtual_furnish_app/core/helpers/auth_provider.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

class AuthRepo {
  //get current user id
  static String? getCurrentUserId() {
    if(FirebaseAuth.instance.currentUser != null)
    return FirebaseAuth.instance.currentUser!.uid;
  }
//1. Login anonymously with firebase
  static Future<String> addGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return "Login Success";
    } catch (e) {
      return e.toString();
    }
  }

//Register with email and password
  static Future<String> registerWithEmailandPassword(
      String email, String password) async {
    try {
     
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {}
      return "Register Success";
    } catch (e) {
      return e.toString();
    }
  }

  //register seller with email and password
    static Future<String> registerSellerWithEmailandPassword(
      String email, String password) async {
    try {
     FirebaseApp app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);
      var result = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: email, password: password!);
      return "uid:${result.user!.uid}";
    } catch (e) {
      return e.toString();
    }
  }

//login with email and password
  static Future<String> loginWithEmailandPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Success";
    } catch (e) {
      return e.toString();
    }
  }

//logout
  static Future<String> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Logout Success";
    } catch (e) {
      return e.toString();
    }
  }

//login with google using firebase auth

  static Future<String> signInWithGoogle() async {
    UserCredential? userCredential;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser == true) {
        UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          username: googleUser!.displayName,
          email: googleUser!.email,
          profilePic: googleUser!.photoUrl,
          sell: "",
          deliveredAddress: [],
          contact: "",
          status: "User",
          age: 0
        );
        UserRepo.saveUser(userModel);
      }
      if (userCredential != null) {
        return "Login Success";
      } else {
        return "Login Failed";
      }
    } catch (e) {
      return e.toString();
    }
  }
  
//signin & signup with phone using firebase auth
  static Future<String?> signUpWithPhone(PhoneAuthCredential credential) async {
    try{
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  if(userCredential!=null){
  if (userCredential.additionalUserInfo!.isNewUser == true) {
    UserModel userModel = UserModel(
      id: userCredential.user!.uid,
      username: userCredential.user!.phoneNumber,
      email:  "",
      profilePic:  "",
      sell: "",
      deliveredAddress: [],
      contact: userCredential.user!.phoneNumber,
      status: "User",
      age: 0
    );
    await UserRepo.saveUser(userModel);
    return "Login Success";
  }else{
  return "Login Success";}}
  else{
    return "Login Failed";
  }}catch(e){
      return e.toString();
    }
}}
