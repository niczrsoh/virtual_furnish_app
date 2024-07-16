import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    on<FetchUserProfile>(fetchUserProfile);
    on<ProfileModification>(profileModification);
    on<EditProfileEventButtonEnabled>(editProfileEventButtonEnabled);
  }

  Future<FutureOr<void>> fetchUserProfile(FetchUserProfile event, Emitter<EditProfileState> emit) async {
    UserModel? userModel;
    try{
      userModel = await UserRepo.getUser(event.id);
      if(userModel!=null){
      emit(UserProfileFound(userModel: userModel));}
      else{
      emit(UserProfileError(errorMessage: "User not found"));}
      }
      catch(e){
      emit(UserProfileError(errorMessage: "User not found"));}
    }
  


  FutureOr<void> editProfileEventButtonEnabled(EditProfileEventButtonEnabled event, Emitter<EditProfileState> emit) {
    if(event.isButtonEnabled){
      emit(EditProfileButtonEnabled(isButtonEnabled: true));}
    else{
      emit(EditProfileButtonEnabled(isButtonEnabled: false));
    }
  }

  Future<FutureOr<void>> profileModification(ProfileModification event, Emitter<EditProfileState> emit) async {
    UserModel? userModel;
     UserProfileFound currentState = state as UserProfileFound;
    userModel = UserModel(
      username: event.username??"",
      email:  event.email??"",
      contact: event.contact??"",
      age: event.age??0,
      status: event.status??"",
      profilePic: event.profilePic??"",
    );
    String message = await UserRepo.editUser(userModel);
    if(message=="User Updated"){
      emit(EditProfileSuccess(message: "Profile Updated"));}
    else{
      emit(EditProfileError(errorMessage: e.toString()));}
  }
}
