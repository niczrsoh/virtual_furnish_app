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

class OrderModification extends SellingOrderEvent {
  final String id;
  final String type;
  final String value;
  final int index;
  final String customerID;
  OrderModification(
      {required this.id,
      required this.type,
      required this.index,
      required this.value,
      required this.customerID});
  @override
  List<Object> get props => [id, type, value, customerID];
}
class RequestOrderEdit extends SellingOrderEvent {
  final bool isEdit;
  final String type;
  final int index;
  RequestOrderEdit({required this.isEdit, required this.type, required this.index});
}