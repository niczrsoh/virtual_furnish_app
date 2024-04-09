part of 'sold_list_bloc.dart';

sealed class SoldListState extends Equatable {
  const SoldListState();
  
  @override
  List<Object> get props => [];
}

final class SoldListInitial extends SoldListState {}

final class SoldListFetctedLoading extends SoldListState {}

final class SoldListFetchedSuccess extends SoldListState {
  final List<MarketplaceProductModel> soldListData;
  SoldListFetchedSuccess({required this.soldListData});
  @override
  List<Object> get props => [soldListData];
}

final class SoldListDataFetchedByNameSuccess extends SoldListState {
  final List<MarketplaceProductModel> soldListData;
  SoldListDataFetchedByNameSuccess({required this.soldListData});
  @override
  List<Object> get props => [soldListData];
}

final class SoldListFetctedFail extends SoldListState {}

final class SoldListDataFetchedByTitleSuccess extends SoldListState {
  final List<MarketplaceProductModel> soldListData;
  SoldListDataFetchedByTitleSuccess({required this.soldListData});
  @override
  List<Object> get props => [soldListData];
}

//delete item
final class DeleteItemSuccess extends SoldListState {}
final class DeleteItemFail extends SoldListState {}