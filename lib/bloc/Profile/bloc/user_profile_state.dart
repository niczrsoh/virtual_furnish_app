part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();
  
  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserProfileState {}
final class UserProfileFound extends UserProfileState {
  final UserModel userModel;
  const UserProfileFound( {required this.userModel,});

  @override
  List<Object> get props => [userModel];
}
final class UserProfileError extends UserProfileState {
  final String errorMessage;
  const UserProfileError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
final class UserProfileButtonEnabled implements UserProfileState {
  final bool isButtonEnabled;
  final UserProfileFound? userProfileFound;
  const UserProfileButtonEnabled({required this.isButtonEnabled ,  this.userProfileFound});
  @override
  List<Object> get props => [isButtonEnabled];
  
  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
