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
    if (FirebaseAuth.instance.currentUser != null)
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

  static Future<bool> verifyEmail() async {
    //generate code for login using firebase email
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return false;
  }

//Register with email and password
  static Future<String> registerWithEmailandPassword(
      String email, String password) async {
    bool isVerifiedEmail = false;
    Timer? mytimer;
    String result = "Unknown error"; // Initialize with a default value
      // Create a Completer to handle early termination of the wait
  Completer<void> verificationCompleter = Completer<void>();
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null && credential.user!.uid.isNotEmpty) {
        bool sentEmail = await verifyEmail();

        // Start the timer to check email verification status
        mytimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
          await FirebaseAuth.instance.currentUser!.reload();
          isVerifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
          if (isVerifiedEmail) {
            verificationCompleter.complete(); // Complete the wait if email is verified
            result = "Email Registered Successfully";
            mytimer!.cancel();
          }
        });

        // Wait for the verification or timeout
         Future.delayed(const Duration(seconds: 30)).then((value) {
          if (!isVerifiedEmail) {
            verificationCompleter.complete(); // Complete the wait if email is not verified
            result = "Email Not Verified";
            mytimer!.cancel();
          }
         });
        await verificationCompleter.future;
        print("reg result: $result");
      } else {
        result = "Email Not Registered";
      }
    } catch (e) {
      result = e.toString();
    }

    return result;
  }

  //register seller with email and password
  static Future<String> registerSellerWithEmailandPassword(
      String email, String password) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);
      var result = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password!);
      return "uid:${result.user!.uid}";
    } catch (e) {
      return e.toString();
    }
  }
//determine if user is a guest
  static bool isGuest() {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return true;
    } else {
      return false;
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

//chang epassword
  static Future<String> changePassword(
      String oldPassword, String newPassword) async {
    try {
      var authUser = FirebaseAuth.instance.currentUser;
      var cred = EmailAuthProvider.credential(
          email: authUser!.email!, password: oldPassword);
      var check = await authUser
          .reauthenticateWithCredential(cred)
          .then((value) async => {await authUser.updatePassword(newPassword)});
      if (check != null) {
        return "Successfully changed password";
      } else {
        return "Failed to change password. Please try again.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return "Old password is incorrect. Please try again.";
      } else if (e.code == "weak-password") {
        return "Password is too weak. Please try again.";
      } else if (e.code == "too-many-requests") {
        return "Too many requests. Please try again later.";
      } else {
        return "Failed to change password. Please try again.";
      }
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
            age: 0);
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
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        if (userCredential.additionalUserInfo!.isNewUser == true) {
          UserModel userModel = UserModel(
              id: userCredential.user!.uid,
              username: userCredential.user!.phoneNumber,
              email: "",
              profilePic: "",
              sell: "",
              deliveredAddress: [],
              contact: userCredential.user!.phoneNumber,
              status: "User",
              age: 0);
          await UserRepo.saveUser(userModel);
          return "Login Success";
        } else {
          return "Login Success";
        }
      } else {
        return "Login Failed";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
