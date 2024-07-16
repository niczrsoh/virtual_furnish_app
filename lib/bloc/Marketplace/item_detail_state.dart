part of 'item_detail_bloc.dart';

@immutable
sealed class ItemDetailState {}

sealed class ItemActionState extends ItemDetailState{}
class ItemDetailInitial extends ItemDetailState {}

class ItemDetailFetctedLoading extends ItemDetailState {}
class ItemDetailFetchedSuccess extends ItemDetailState {
  final MarketplaceProductModel itemData;
  final SellerAccountModel sellerData;
  final UserModel userData;
  final bool isGuest;
  ItemDetailFetchedSuccess({
    required this.itemData,
    required this.sellerData,
    required this.userData,
    required this.isGuest,
  });
}
class ItemDetailFetctedFail extends ItemDetailState {}