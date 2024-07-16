part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();
  
  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}
final class CheckoutAddressState extends CheckoutState{}
final class CheckoutAddressActionState extends CheckoutAddressState{}
final class CheckoutAddressAdded extends CheckoutAddressActionState{
  CheckoutAddressAdded();
}

final class CheckoutAddressRemoved extends CheckoutAddressActionState{
  CheckoutAddressRemoved();
}

final class CheckoutAddressChanged extends CheckoutAddressActionState{
  CheckoutAddressChanged();
}
final class CheckoutAddressLoaded extends CheckoutAddressState{
  final List<String> address;
  CheckoutAddressLoaded({required this.address});
}
final class CheckoutAddressEmpty extends CheckoutAddressState{
  CheckoutAddressEmpty();
}
final class CheckoutAddressError extends CheckoutAddressActionState{
  final String message;
  CheckoutAddressError({required this.message});
}

final class CheckoutLoaded extends CheckoutState {
  final List<CartProductModel> cartProducts;
  final List<CheckoutModel> checkoutProducts;
  final double totalPayment;
  final List<String> address;
  CheckoutLoaded({required this.checkoutProducts, required this.cartProducts, required this.totalPayment, required this.address});
}

final class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError({required this.message});
}