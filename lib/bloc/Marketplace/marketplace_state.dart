part of 'marketplace_bloc.dart';

sealed class MarketplaceState extends Equatable {
  const MarketplaceState();
  
  @override
  List<Object> get props => [];
}

final class MarketplaceInitial extends MarketplaceState {}
