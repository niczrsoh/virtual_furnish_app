part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}
class UserProfileFetched extends UserProfileEvent {
  const UserProfileFetched();
  @override
  List<Object> get props => [];
}
class UserProfileEventButtonEnabled extends UserProfileEvent {
  final bool isButtonEnabled;
  const UserProfileEventButtonEnabled({required this.isButtonEnabled});
  @override
  List<Object> get props => [];
}