part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}
final class LoadCart extends CartEvent {
  LoadCart();
}

final class AddToCart extends CartEvent {
  final int amount;
  final String priority;
  final String productID;

  AddToCart(this.amount, this.priority, this.productID);
}

final class RemoveFromCart extends CartEvent {
  final String productID;

  RemoveFromCart(this.productID);
}

final class UpdateCartProduct extends CartEvent {
  final String id;
  final int amount;
  final String priority;

  UpdateCartProduct(this.id, this.amount, this.priority);
}

final class SelectAllCartProduct extends CartEvent {
  SelectAllCartProduct();
}

final class UnSelectCartProduct extends CartEvent {
  final String id;
  UnSelectCartProduct(this.id);
}

final class UnSelectAllCartProduct extends CartEvent {
  UnSelectAllCartProduct();
}

final class SelectCartProduct extends CartEvent {
  final String id;
  SelectCartProduct(this.id);
}

final class CartProductPageButtonPressed extends CartEvent {
  CartProductPageButtonPressed();
}

