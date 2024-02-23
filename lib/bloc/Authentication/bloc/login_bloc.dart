import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<FillLoginForm>(fillLoginForm);
    on<SelectGoogleAccount>(selectGoogleAccount);
    on<AddPhoneNumber>(addPhoneNumber);
    on<AddGuest>(addGuest);
    on<LoginPageEnableButton>(enableButton);
  }

  FutureOr<void> fillLoginForm(FillLoginForm event, Emitter<LoginState> emit) {
  }
  Future<FutureOr<void>> selectGoogleAccount(SelectGoogleAccount event, Emitter<LoginState> emit) async {
      String message = await AuthRepo.signInWithGoogle();
      if (message == "Login Success") {
        
        emit(LoginSuccess(message: message));
      } else {
        emit(LoginFail(message: message));
      }
  }
  FutureOr<void> addPhoneNumber(AddPhoneNumber event, Emitter<LoginState> emit) {
    
  }
  Future<FutureOr<void>> addGuest(AddGuest event, Emitter<LoginState> emit) async {
      String message = await AuthRepo.addGuest();
      if (message == "Login Success") {
        emit(LoginSuccess(message: message));
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
}
