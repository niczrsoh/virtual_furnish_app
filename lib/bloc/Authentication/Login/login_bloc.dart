import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<FillLoginForm>(fillLoginForm);
    on<SelectGoogleAccount>(selectGoogleAccount);
    on<AddPhoneNumber>(addPhoneNumber);
    on<AddGuest>(addGuest);
    on<LoginPageEnableButton>(enableButton);
    on<VerifyCode>(verifyCode);
  }
  FutureOr<void> fillLoginForm(FillLoginForm event, Emitter<LoginState> emit) async {
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      String message = await AuthRepo.loginWithEmailandPassword(event.email, event.password);
       String userType= await SellerRepo.isSeller(AuthRepo.getCurrentUserId()!);
      if(message == "Login Success"){
      emit(LoginSuccess(message: message, userType: userType));}
      else{
        emit(LoginFail(message: message));
      } 
    } else {
      emit(LoginFail(message: "Login  Failed"));
    }
  }
  Future<FutureOr<void>> selectGoogleAccount(SelectGoogleAccount event, Emitter<LoginState> emit) async {
      String message = await AuthRepo.signInWithGoogle();
       String userType= await SellerRepo.isSeller(AuthRepo.getCurrentUserId()!);
      if (message == "Login Success") {
        emit(LoginSuccess(message: message, userType: userType));
      } else {
        emit(LoginFail(message: message));
      }
  }
  Future<void> addPhoneNumber(AddPhoneNumber event, Emitter<LoginState> emit)  async{
    final FirebaseAuth auth = FirebaseAuth.instance;

      auth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async  {
           auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          // Verification failed
          if (e.code == 'invalid-phone-number') {
            emit(CodeFailed(message: "Invalid Phone Number"));
          }
        },
        codeSent: (String verificationId, int? resendToken)  async {
        //release a state that will show the code input field
           emit(CodeSent(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 60),
      );
  }


  Future<FutureOr<void>> addGuest(AddGuest event, Emitter<LoginState> emit) async {
      String message = await AuthRepo.addGuest();
       String userType= await SellerRepo.isSeller(AuthRepo.getCurrentUserId()!);
      if (message == "Login Success") {
        emit(LoginSuccess(message: message, userType: userType));
      } else {
        emit(LoginFail(message: message));
      }
  }


  FutureOr<void> enableButton(LoginPageEnableButton event, Emitter<LoginState> emit) {
    if(event.isButtonEnabled){
      emit(LoginPageButtonEnabled(isButtonEnabled: true));}
    else{
      emit(LoginPageButtonEnabled(isButtonEnabled: false));
    }
  }

  Future<FutureOr<void>> verifyCode(VerifyCode event, Emitter<LoginState> emit) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: event.verificationId, smsCode: event.code);
    //create phone user in the firebase if first time login 
    // else login the user
    await AuthRepo.signUpWithPhone(credential).then((value) => {
      if(value == "Login Success"){
        emit(CodeVerified(message: "Code Verified"))
      }else{
        emit(CodeFailed(message: "Code Verification Failed"))
      }
    });
  
  }
}
