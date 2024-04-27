part of 'marketplace_bloc.dart';

sealed class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();

  @override
  List<Object> get props => [];
}

//search event
final class SearchEvent extends MarketplaceEvent {
  final String searchQuery;

  SearchEvent({required this.searchQuery});

}

//fetch most selling items event
final class FetchMostSellingItems extends MarketplaceEvent {
  FetchMostSellingItems();
}