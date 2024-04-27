part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentStart extends PaymentEvent {}

class PaymentCreateIntent extends PaymentEvent {
  final BillingDetails billingDetails;
  final List<CartProductModel> items;
  final double total;
  PaymentCreateIntent({required this.billingDetails, required this.items, required this.total});

  @override
  List<Object> get props => [billingDetails, items];
}

class PaymentConfirmIntent extends PaymentEvent {
  final String clientSecret;

  PaymentConfirmIntent({required this.clientSecret});

  @override
  List<Object> get props => [clientSecret];
}
