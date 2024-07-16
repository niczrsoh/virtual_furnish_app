part of 'selling_order_bloc.dart';

sealed class SellingOrderState extends Equatable{
  const SellingOrderState();
  @override
  List<Object> get props => [];
}

final class SellingOrderInitial extends SellingOrderState {}
final class SellingOrderActionState extends SellingOrderState {}

final class SellingOrderLoading extends SellingOrderState {}

final class SellingOrderLoaded extends SellingOrderState {
  final List<MarketOrder> items;
  final List<MarketplaceProductModel> product_model;
  SellingOrderLoaded({required this.items, required this.product_model});
  
  @override
  List<Object> get props => [items, product_model];
}
final class SellingOrderEmpty extends SellingOrderState {}
final class SellingOrderError extends SellingOrderState {
  final String message;
  SellingOrderError({required this.message});
}


//update item
final class UpdateOrderItemSuccess extends SellingOrderActionState {
  final String value;
  final String type;
  final int index;
  final MarketOrder? item;
  UpdateOrderItemSuccess({required this.value, required this.type, required this.index,  this.item});
  @override
  List<Object> get props => [value, type, index];
}
final class UpdateOrderItemFail extends SellingOrderActionState {}

//request edit
final class OrderRequestEditSuccess extends SellingOrderActionState {
  final bool isEdit;
  final String type;
  final int index;
  OrderRequestEditSuccess({required this.type,required this.isEdit, required this.index});
  @override
  List<Object> get props => [type, isEdit, index];
}
final class OrderRequestEditFail extends SellingOrderActionState {}
