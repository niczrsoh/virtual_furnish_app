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