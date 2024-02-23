import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

class AuthRepo {
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
          id: credential.idToken,
          username: googleUser!.displayName,
          email: googleUser!.email,
          profilePic: googleUser!.photoUrl,
          sell: "",
          deliveredAddress: [],
          contact: "",
          status: ""
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

//login with phone using firebase auth
  static Future<String?> signInWithPhone(String phoneNo) async {
    String? id;
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phoneNo,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          id = value.toString();
          print("You are logged in successfully");
          return id;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, [int? forceResendingToken]) async {
        print('verificationId: $verificationId');
        print('forceResendingToken: $forceResendingToken');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
