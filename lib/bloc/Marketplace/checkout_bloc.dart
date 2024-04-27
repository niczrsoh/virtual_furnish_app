import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/checkout_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/checkout_payment_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';    

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial()) {
    on<LoadCheckout>(loadCheckout);
  }
  double totalPayment = 0;
  Future<FutureOr<void>> loadCheckout(LoadCheckout event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    //seperate each product by seller
    List<CheckoutModel> checkoutProducts = await CheckoutPaymentRepo().mapProductsToSellers(event.cartProducts);
    //calculate the total payment
    for (CheckoutModel checkout in checkoutProducts) {
      totalPayment += checkout.totalPayment!;
    }
    try {
      emit(CheckoutLoaded(cartProducts: event.cartProducts, checkoutProducts: checkoutProducts, totalPayment: totalPayment));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }
}
