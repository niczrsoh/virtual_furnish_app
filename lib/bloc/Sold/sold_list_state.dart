part of 'sold_list_bloc.dart';

sealed class SoldListState {
  const SoldListState();
  
}
sealed class SoldListActionState extends SoldListState{}
sealed class SoldListConditionState extends SoldListState{}
final class SoldListInitial extends SoldListState {}

final class SoldListFetctedLoading extends SoldListState {}

final class SoldListFetchedSuccess extends SoldListState {
  final List<MarketplaceProductModel> soldListData;
  SoldListFetchedSuccess({required this.soldListData});
}
final class SoldListFetchedSuccessEmpty extends SoldListState {
  SoldListFetchedSuccessEmpty();
}

final class SoldListDataFetchedByNameSuccess extends SoldListState {
  final List<MarketplaceProductModel> soldListData;
  SoldListDataFetchedByNameSuccess({required this.soldListData});
}

final class SoldListFetctedFail extends SoldListState {}

final class SoldListDataFetchedByTitleSuccess extends SoldListState {
  final List<MarketplaceProductModel> soldListData;
  SoldListDataFetchedByTitleSuccess({required this.soldListData});
}

//delete item
final class DeleteItemSuccess extends SoldListActionState {}
final class DeleteItemFail extends SoldListActionState {}

//update item
final class UpdateItemSuccess extends SoldListActionState {
  final String value;
  final String type;
  final int index;
  UpdateItemSuccess({required this.value, required this.type, required this.index});

}
final class UpdateItemFail extends SoldListActionState {}

//request edit
final class RequestEditSuccess extends SoldListActionState {
  final bool isEdit;
  final String type;
  final int index;
  RequestEditSuccess({required this.type,required this.isEdit, required this.index});
}
final class RequestEditFail extends SoldListActionState {}