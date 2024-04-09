import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<UserProfileFetched>(userProfileFetched);
    on<UserProfileEventButtonEnabled>(userProfileEventButtonEnabled);
    
  }

  FutureOr<void> userProfileEventButtonEnabled(UserProfileEventButtonEnabled event, Emitter<UserProfileState> emit) {
    UserProfileFound profileState = state as UserProfileFound;
    if(event.isButtonEnabled){
     emit(UserProfileButtonEnabled(isButtonEnabled: true, userProfileFound: profileState));
     }
    else{
     emit(UserProfileButtonEnabled(isButtonEnabled: false, userProfileFound: profileState));
    }
  }

  Future<FutureOr<void>> userProfileFetched(UserProfileFetched event, Emitter<UserProfileState> emit) async {
    String? id = AuthRepo.getCurrentUserId();
    UserModel? userModel;
    if(id!=null){
    userModel = await UserRepo.getUser(id);
    if(userModel!=null){
      emit(UserProfileFound(userModel: userModel));
    }
    else{
      emit(UserProfileError(errorMessage: "User not found"));
    }
    }
  }
}
