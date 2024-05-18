part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable{
  const UserProfileState();
  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserProfileState {}
final class UserProfileActionState extends UserProfileState {}

final class UserProfileFound extends UserProfileState {
  final UserModel userModel;
  final bool isGuest;
  final int orderNo;
  const UserProfileFound( {required this.userModel,required this.isGuest, required this.orderNo});
  @override
  List<Object> get props => [userModel,isGuest, orderNo];

}
final class UserProfileError extends UserProfileState {
  final String errorMessage;
  const UserProfileError({required this.errorMessage});
}
final class UserProfileButtonEnabled implements UserProfileActionState {
  final bool isButtonEnabled;
  const UserProfileButtonEnabled({required this.isButtonEnabled});
  @override
  List<Object> get props => [];
  
  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();

}
