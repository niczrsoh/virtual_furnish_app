part of 'seller_profile_bloc.dart';

sealed class SellerProfileEvent extends Equatable {
  const SellerProfileEvent();

  @override
  List<Object> get props => [];
}

class SellerProfileSearch extends SellerProfileEvent {
  SellerProfileSearch();
}