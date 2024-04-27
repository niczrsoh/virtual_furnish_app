part of 'selling_order_bloc.dart';

sealed class SellingOrderState extends Equatable {
  const SellingOrderState();
  
  @override
  List<Object> get props => [];
}

final class SellingOrderInitial extends SellingOrderState {}
final class SellingOrderActionState extends SellingOrderState {}

final class SellingOrderLoading extends SellingOrderState {}

final class SellingOrderLoaded extends SellingOrderState {
  final List<MarketOrder> items;
  SellingOrderLoaded({required this.items});
}

final class SellingOrderError extends SellingOrderState {
  final String message;
  SellingOrderError({required this.message});
}

final class SellingOrderUpdated extends SellingOrderState {
  final String orderId;
  SellingOrderUpdated({required this.orderId});
}