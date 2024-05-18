part of 'order_detail_bloc.dart';

sealed class OrderDetailState extends Equatable {
  const OrderDetailState();
  
  @override
  List<Object> get props => [];
}

final class OrderDetailInitial extends OrderDetailState {}

final class OrderDetailLoading extends OrderDetailState {}

final class OrderDetailLoaded extends OrderDetailState {
  final List<OrderStatus> orders;
  final String type;
  final List<MarketplaceProductModel> product_model;
  OrderDetailLoaded(this.orders, this.type, this.product_model);
}

final class OrderDetailError extends OrderDetailState {
  final String message;

  OrderDetailError(this.message);
}

final class OrderDetailEmpty extends OrderDetailState {}