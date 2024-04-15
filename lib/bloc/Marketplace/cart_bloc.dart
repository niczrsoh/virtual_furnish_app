import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/cart_product_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCart> (loadCart);
    on<AddToCart> (addToCart);
    on<RemoveFromCart> (removeFromCart);
    on<UpdateCartProduct> (updateCartProduct);
    on<SelectAllCartProduct> (selectAllCartProduct);
    on<SelectCartProduct> (selectCartProduct);
    on<UnSelectCartProduct> (unSelectCartProduct);
    on<UnSelectAllCartProduct> (unSelectAllCartProduct);
    on<CartProductPageButtonPressed> (cartProductPageButtonPressed);
  }
  double totalPrice = 0;
  FutureOr<void> addToCart(AddToCart event, Emitter<CartState> emit) {
    //add into cart
    CartProductModel cartProduct = CartProductModel(productID: event.productID,amount: event.amount,priority: event.priority);
    CartProductRepo.addProductToCart(cartProduct).then((value) {
      emit(CartProductAdded());
    }).catchError((e) {
      emit(CartError(e.toString()));
    });
  }

  FutureOr<void> removeFromCart(RemoveFromCart event, Emitter<CartState> emit) {

  }

  FutureOr<void> updateCartProduct(UpdateCartProduct event, Emitter<CartState> emit) async {
    CartProductModel cartProduct = CartProductModel(id: event.id,amount: event.amount,priority: event.priority);
      int indexOfUpdatedProduct = state.cartProducts!.indexWhere((product) => product.id == event.id);
    if (indexOfUpdatedProduct != -1) {
      // Create a copy of the current products list
      List<CartProductModel>? updatedProducts = state.cartProducts;

      // Update the product at the specified index
      updatedProducts![indexOfUpdatedProduct] = cartProduct;
      List<CartProductModel> selectedCartProducts = state.selectedCartProducts??[];
      if(selectedCartProducts.isEmpty)selectedCartProducts.add(cartProduct);
      else{
        int indexOfSelectedProduct = selectedCartProducts.indexWhere((element) => element.id == event.id);
        if(indexOfSelectedProduct != -1){
          selectedCartProducts[indexOfSelectedProduct] = cartProduct;
        }
        else{
          selectedCartProducts.add(cartProduct);
        }
      }
      //recalculate total price based on selected product
      totalPrice = selectedCartProducts.fold(0, (previousValue, element) => previousValue + (element.amount!*state.products![state.cartProducts!.indexOf(element)].price!));
      String message = await CartProductRepo.updateCartProduct(cartProduct);
      if(message == "Successfully Updated"){
      // Emit the updated state with the updated product list
      emit(CartProductUpdated(state.selectedCartProducts!,updatedProducts,state.products!,totalPrice));}
      else{
        emit(CartError(message));
      }
    } else {
      // Handle case where the product to update was not found in the current state
      emit(CartError("Product with ID ${event.id} not found in the cart."));
    } 
  }

  FutureOr<void> loadCart(LoadCart event, Emitter<CartState> emit) async{
    List<CartProductModel> cartProducts = await CartProductRepo.getCartProducts();

    List<Future<MarketplaceProductModel>> productFutures = cartProducts.map((product) {
      return MarketplaceRepo.getSellingItem(product.productID!);
    }).toList();

    List<MarketplaceProductModel> products = await Future.wait(productFutures);
    emit(CartListFetchedSuccess(cartProducts, products,0,[]));
  }

  FutureOr<void> selectAllCartProduct(SelectAllCartProduct event, Emitter<CartState> emit) {
   //find cart products based on id
    List<CartProductModel> selectedCartProducts = state.cartProducts!;
    totalPrice = selectedCartProducts.fold(0, (previousValue, element) => previousValue + (element.amount!*state.products![state.cartProducts!.indexOf(element)].price!));
    emit(CartProductSelected(selectedCartProducts,state.cartProducts!,state.products!,totalPrice!));
  }

  FutureOr<void> selectCartProduct(SelectCartProduct event, Emitter<CartState> emit) {
    //find cart products based on id
    CartProductModel selectedCartProducts = state.cartProducts!.where((element) => element.id == event.id).first;
    totalPrice = state.totalPrice!+selectedCartProducts.amount!*state.products![state.cartProducts!.indexOf(selectedCartProducts)].price!;
    emit(CartProductSelected(state.selectedCartProducts!..add(selectedCartProducts),state.cartProducts!,state.products!,totalPrice!));
  }

  FutureOr<void> unSelectAllCartProduct(UnSelectAllCartProduct event, Emitter<CartState> emit) {
    totalPrice = 0;
    emit(CartProductSelected([],state.cartProducts!,state.products!,totalPrice!));
  }

  FutureOr<void> unSelectCartProduct(UnSelectCartProduct event, Emitter<CartState> emit) {
    //find cart products based on id
    CartProductModel selectedCartProducts = state.cartProducts!.where((element) => element.id == event.id).first;
    totalPrice = state.totalPrice!-selectedCartProducts.amount!*state.products![state.cartProducts!.indexOf(selectedCartProducts)].price!;
    emit(CartProductSelected(state.selectedCartProducts!..remove(selectedCartProducts),state.cartProducts!,state.products!,totalPrice!));
  }

  //able to checkout or not

  FutureOr<void> cartProductPageButtonPressed(CartProductPageButtonPressed event, Emitter<CartState> emit) {
    bool isButtonDisabled = state.selectedCartProducts==null?true:state.selectedCartProducts!.isEmpty;
    emit(CartProductPageButtonState(isButtonDisabled,state.selectedCartProducts!,state.cartProducts!,state.products!,state.totalPrice!));
  }
}
