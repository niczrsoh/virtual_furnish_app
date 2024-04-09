part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends EditProfileEvent {
  final String id;
  FetchUserProfile({required this.id});
}


class ProfileModification extends EditProfileEvent {
  final String? username;
  final String? email;
  final String? contact;
  final String? status;
  final int? age;
  final String? profilePic;
  ProfileModification(
      {
        this.username,
        this.email,
        this.contact,
       this.status,
       this.profilePic,
       this.age});
}

class EditProfileEventButtonEnabled extends EditProfileEvent {
  final bool isButtonEnabled;
  EditProfileEventButtonEnabled({required this.isButtonEnabled});
}

class EditProfileImage extends EditProfileEvent {
  final String profilePic;
  EditProfileImage({required this.profilePic});
}

class EditProfileStatus extends EditProfileEvent {
  final String status;
  EditProfileStatus({required this.status});
}