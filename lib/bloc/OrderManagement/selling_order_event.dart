part of 'selling_order_bloc.dart';

sealed class SellingOrderEvent extends Equatable {
  const SellingOrderEvent();

  @override
  List<Object> get props => [];
}


class FetchItems extends SellingOrderEvent {
  FetchItems();
}

class UpdateStatus extends SellingOrderEvent {
  final String orderId;
  UpdateStatus({required this.orderId});
}
