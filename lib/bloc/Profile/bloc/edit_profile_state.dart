part of 'edit_profile_bloc.dart';

sealed class EditProfileState extends Equatable {
   EditProfileState();
  @override
  List<Object> get props => [];
}

final class EditProfileInitial extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final String message;
  EditProfileSuccess({required this.message});
}

class EditProfileError extends EditProfileState {
  final String errorMessage;
  EditProfileError({required this.errorMessage});
}

class EditProfileButtonEnabled extends EditProfileState {
  final bool isButtonEnabled;
  EditProfileButtonEnabled({required this.isButtonEnabled});
}

class UserProfileFound extends EditProfileState {
  final UserModel userModel;
  UserProfileFound({required this.userModel});
  //copyWith
   UserProfileFound copyWith({
    UserModel? userModel,
  }) {
    return UserProfileFound(
        userModel: userModel ?? this.userModel,
      );
  }

  //add into props
  @override
  List<Object> get props => [];
}

class UserProfileError extends EditProfileState {
  final String errorMessage;
  UserProfileError({required this.errorMessage});
}

class EditProfileImageEdited extends EditProfileState {
  final String profilePic;
  EditProfileImageEdited({required this.profilePic});
}

class EditProfileStatusEdited extends EditProfileState {
  final String status;
  EditProfileStatusEdited({required this.status});
}
