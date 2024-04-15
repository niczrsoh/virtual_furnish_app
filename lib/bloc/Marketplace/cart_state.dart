part of 'cart_bloc.dart';

sealed class CartState extends Equatable{
   CartState({this.cartProducts, this.products, this.totalPrice, this.selectedCartProducts});
  List<CartProductModel>? cartProducts;
  List<CartProductModel>? selectedCartProducts = [];
  List<MarketplaceProductModel>? products;
  double? totalPrice;
  @override
  List<Object?> get props => [cartProducts, products, totalPrice, selectedCartProducts];
}

final class CartInitial extends CartState {}

final class CartListFetchedSuccess extends CartState {
  final List<CartProductModel> cartProducts;
  final List<MarketplaceProductModel> products;
  final double totalPrice;
  final List<CartProductModel> selectedCartProducts;
  CartListFetchedSuccess(this.cartProducts, this.products, this.totalPrice, this.selectedCartProducts):super(cartProducts: cartProducts, products: products, totalPrice: totalPrice, selectedCartProducts: selectedCartProducts);


  // static CartState copyWith(List<CartProductModel> updatedProducts, List<MarketplaceProductModel> list) {
  //   return CartListFetchedSuccess(updatedProducts, list);
  // }
}

final class CartError extends CartState {
  final String message;

  CartError(this.message);

}

final class CartProductAdded extends CartState {}
final class CartProductRemoved extends CartState {}
final class CartProductUpdated extends CartState {
    final List<CartProductModel> cartProducts;
  final List<MarketplaceProductModel> products;
  final List<CartProductModel> selectedCartProducts;
  final double totalPrice;
  CartProductUpdated(this.selectedCartProducts,this.cartProducts, this.products, this.totalPrice):super(selectedCartProducts: selectedCartProducts,cartProducts: cartProducts, products: products, totalPrice: totalPrice);

}

final class CartProductSelected extends CartState {
    final List<CartProductModel> cartProducts;
  final List<MarketplaceProductModel> products;
  final double totalPrice;
  final List<CartProductModel> selectedCartProducts;
  CartProductSelected(this.selectedCartProducts,this.cartProducts, this.products, this.totalPrice):super(selectedCartProducts: selectedCartProducts, cartProducts: cartProducts, products: products, totalPrice: totalPrice);
}

final class CartProductPageButtonState extends CartState {
  final List<CartProductModel> cartProducts;
  final List<MarketplaceProductModel> products;
  final double totalPrice;
  final List<CartProductModel> selectedCartProducts;
  final bool isButtonDisabled;
  CartProductPageButtonState(this.isButtonDisabled,this.selectedCartProducts,this.cartProducts, this.products, this.totalPrice):super(selectedCartProducts: selectedCartProducts, cartProducts: cartProducts, products: products, totalPrice: totalPrice);
}