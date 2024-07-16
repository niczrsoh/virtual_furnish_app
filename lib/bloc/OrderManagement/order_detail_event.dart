part of 'order_detail_bloc.dart';

sealed class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchOrderByType extends OrderDetailEvent {
  final String type;

  FetchOrderByType(this.type);
}

class ConfirmItem extends OrderDetailEvent {
  final String orderID;

  ConfirmItem(this.orderID);
}


