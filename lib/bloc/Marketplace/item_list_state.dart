part of 'item_list_bloc.dart';

@immutable
sealed class ItemListState {}

sealed class ItemActionState extends ItemListState{}
class ItemListInitial extends ItemListState {}

class ItemListFetctedLoading extends ItemListState {}
class ItemListFetchedSuccess extends ItemListState {
  final List<MarketplaceProductModel> itemData;
  ItemListFetchedSuccess({
    required this.itemData,
  });
}
class ItemListFetctedFail extends ItemListState {}
class ItemListFetchedByNameSuccess extends ItemListState {
  final List<MarketplaceProductModel> itemData;
  ItemListFetchedByNameSuccess({
    required this.itemData,
  });
}