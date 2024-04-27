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
  ItemDetailFetchedSuccess({
    required this.itemData,
    required this.sellerData,
    required this.userData,
  });
}
class ItemDetailFetctedFail extends ItemDetailState {}