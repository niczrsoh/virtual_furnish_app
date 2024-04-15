part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();
  
  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<CartProductModel> cartProducts;
  final List<CheckoutModel> checkoutProducts;
  final double totalPayment;
  CheckoutLoaded({required this.checkoutProducts, required this.cartProducts, required this.totalPayment});
}

final class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError({required this.message});
}