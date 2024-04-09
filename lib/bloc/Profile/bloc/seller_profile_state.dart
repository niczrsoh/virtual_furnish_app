part of 'seller_profile_bloc.dart';

sealed class SellerProfileState extends Equatable {
  const SellerProfileState();
  
  @override
  List<Object> get props => [];
}

final class SellerProfileInitial extends SellerProfileState {}

final class SellerProfileFoundState extends SellerProfileState {
  SellerProfileFoundState({required this.sellerProfile, required this.userProfile});
  final UserModel userProfile;
  final SellerAccountModel sellerProfile;
  @override
  List<Object> get props => [sellerProfile, userProfile];
}

final class SellerProfileError extends SellerProfileState {
  SellerProfileError({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}