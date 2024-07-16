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
    on<LoadAddress>(loadAddress);
    on<AddAddress>(addAddress);
    on<ChangeAddress>(changeAddress);
    on<RemoveAddress>(removeAddress);
  }

  Future<FutureOr<void>> loadCheckout(
      LoadCheckout event, Emitter<CheckoutState> emit) async {
    double totalPayment = 0;
    emit(CheckoutLoading());
    //seperate each product by seller
    List<CheckoutModel> checkoutProducts =
        await CheckoutPaymentRepo.mapProductsToSellers(event.cartProducts);
    //get address
    List<String> address = await CheckoutPaymentRepo.getAddress();

    //calculate the total payment
    for (CheckoutModel checkout in checkoutProducts) {
      totalPayment += checkout.totalPayment!;
    }
    try {
      emit(CheckoutLoaded(
          cartProducts: event.cartProducts,
          checkoutProducts: checkoutProducts,
          totalPayment: totalPayment,
          address: address));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  FutureOr<void> loadAddress(
      LoadAddress event, Emitter<CheckoutState> emit) async {
    //get the address from the user
    await CheckoutPaymentRepo.getAddress().then((value) {
      if (value.isEmpty) {
        emit(CheckoutAddressEmpty());
      } else {
        emit(CheckoutAddressLoaded(address: value));
      }
    });
  }

  FutureOr<void> addAddress(
      AddAddress event, Emitter<CheckoutState> emit) async {
    //add the address to the user
    String result = await CheckoutPaymentRepo.addAddress(event.address);
    if (result == "Address Added") {
      emit(CheckoutAddressAdded());
      add(LoadAddress());
    } else
      emit(CheckoutAddressError(message: result));
  }

  FutureOr<void> changeAddress(
      ChangeAddress event, Emitter<CheckoutState> emit) async {
    String result = await CheckoutPaymentRepo.changeAddress(event.address);
    if (result == "Address Changed") {
      emit(CheckoutAddressChanged());
      add(LoadAddress());
    } else
      emit(CheckoutAddressError(message: result));
  }

  FutureOr<void> removeAddress(
      RemoveAddress event, Emitter<CheckoutState> emit) {
    //remove the address from the user
    CheckoutPaymentRepo.removeAddress(event.address);
    emit(CheckoutAddressRemoved());
    add(LoadAddress());
  }
}
