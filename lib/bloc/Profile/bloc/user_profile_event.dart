part of 'user_profile_bloc.dart';

sealed class UserProfileEvent{
  const UserProfileEvent();

  // @override
  // List<Object> get props => [];
}
class UserProfileFetched extends UserProfileEvent {
  const UserProfileFetched();
}

class UserProfileEventButtonEnabled extends UserProfileEvent {
  final bool isButtonEnabled;
  const UserProfileEventButtonEnabled({required this.isButtonEnabled});
}