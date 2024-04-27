part of 'marketplace_bloc.dart';

sealed class MarketplaceState{
  const MarketplaceState();
  
}

final class MarketplaceInitial extends MarketplaceState {}

final class MarketplaceActionState extends MarketplaceState {}
final class ItemsSearched extends MarketplaceActionState {
  final String searchQuery;
  ItemsSearched({
    required this.searchQuery,
  });
}

final class MostSellingItemsFetched extends MarketplaceState {
  final List<MarketplaceProductModel> items;
  MostSellingItemsFetched({
    required this.items,
  });
}
final class MarketplaceItemsEmpty extends MarketplaceState {}

final class MarketplaceError extends MarketplaceState {
  final String errorMessage;
  MarketplaceError({
    required this.errorMessage,
  });
}