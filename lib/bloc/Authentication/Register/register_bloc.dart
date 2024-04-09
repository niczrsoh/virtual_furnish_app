import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterCreation>(registerCreation);
    on<RegisterPageEnableButton>(enableButton);
  }

  Future<FutureOr<void>> registerCreation(RegisterCreation event, Emitter<RegisterState> emit) async {
    final message = await AuthRepo.registerWithEmailandPassword(event.email, event.password);
      if (message == "Register Success") {
        UserModel userModel = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          username: event.name,
          email: event.email,
          profilePic: "",   
          sell: "",
          age: 0,
          deliveredAddress: [],
          contact: "",
          status: "Active",
        );
        final value = await UserRepo.saveUser(userModel);
        if (value == "User Added") {
          emit(RegisterSuccess(message: message));
        } else {
          emit(RegisterFail(message: message));
        }
      } else {
        emit(RegisterFail(message: message));
      }
    }
  }


  FutureOr<void> enableButton(RegisterPageEnableButton event, Emitter<RegisterState> emit) {
    if(event.isButtonEnabled){
      emit(RegisterPageButtonEnabled(isButtonEnabled: true));}
    else{
      emit(RegisterPageButtonEnabled(isButtonEnabled: false));
    }
  }

