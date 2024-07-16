part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

final class LoadCheckout extends CheckoutEvent {
  final List<CartProductModel> cartProducts;
  LoadCheckout({required this.cartProducts});
}

final class ChangeAddress extends CheckoutEvent {
  final String address;
  ChangeAddress({required this.address});
}

final class AddAddress extends CheckoutEvent {
  final String address;
  AddAddress({required this.address});
}

final class RemoveAddress extends CheckoutEvent {
  final String address;
  RemoveAddress({required this.address});
}

final class LoadAddress extends CheckoutEvent {
  LoadAddress();
}