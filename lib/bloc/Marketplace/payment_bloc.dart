import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/payment_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/market_order_model.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/order_status_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/cart_product_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/payment_repo.dart';
import 'package:virtual_furnish_app/data/repo/OrderManagement/order_repo.dart';
part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<PaymentStart>(_onPaymentStart);
    on<PaymentCreateIntent>(_onPaymentCreateIntent);
   // on<PaymentConfirmIntent>(_onPaymentConfirmIntent);
  }

  FutureOr<void> _onPaymentStart(
      PaymentStart event, Emitter<PaymentState> emit) {
    emit(state.copyWith(status: PaymentStatus.initial));
  }

  Future<FutureOr<void>> _onPaymentCreateIntent(
      PaymentCreateIntent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
      paymentMethodData: PaymentMethodData(
        billingDetails: event.billingDetails,
      ),
    ));
    final paymentIntentResults = await _callPayEndPointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd',
        total: event.total);
    String? userID = AuthRepo.getCurrentUserId();
    print("paymentIntentResults: "+paymentIntentResults.toString());
    if (paymentIntentResults["client_secret"] != null) {
      bool flag = true;
      /*
      add payment data to firestore, remove the cart items, add selling order, 
      add order status and reduce the amount of marketplace product+add the amount to the buyer
      */
      for(int i=0;i<event.items.length;i++){
      PaymentRepo.createPayment(PaymentModel(
          id: paymentMethod.id,
          amount: event.items[i].amount,
          cartID: event.items[i].id,
          method: paymentMethod.paymentMethodType,
          account: paymentMethod.usBankAccount.linkedAccount,
      ));
      String resultCart = await CartProductRepo.removeProductFromCart(event.items[i]);
      MarketOrder marketOrder = MarketOrder(
        amount: event.items[i].amount,
        productID: event.items[i].productID,
        courier: "",
        status: 'process',
        customerID: userID,
        transactionNumber: "",
      );
      OrderStatus orderStatus = OrderStatus(
        amount: event.items[i].amount,
        productID: event.items[i].productID,
        from: "",
        status: 'process',
        latestTransaction: "Seller is processing your order",
        trackingNumber: "",
      );
      String resultProductBuyer = await MarketplaceRepo.buyProduct(event.items[i].productID!, event.items[i].amount!);
      MarketplaceProductModel model = await MarketplaceRepo.getSellingItem(event.items[i].productID!);
      String resultSellOrder = await OrderRepo.createOrder(marketOrder, model.sellerID!);
      String resultOrderStatus = await OrderRepo.createOrderStatus(orderStatus, userID!);
      if(resultOrderStatus != "Order Status Created" || resultSellOrder != "Order Created" || resultCart != "Successfully Removed" || resultProductBuyer != "Product Bought"){
       flag = false;
       break;
      }
      print("finish ${i}");
      }
      if(flag == true){
      emit(state.copyWith(status: PaymentStatus.success));}
      else{
        emit(state.copyWith(status: PaymentStatus.failure));
      }
    }
  }

  // Future<FutureOr<void>> _onPaymentConfirmIntent(
  //     PaymentConfirmIntent event, Emitter<PaymentState> emit) async {
  //   try {
  //     final paymentIntent =
  //         await Stripe.instance.handleNextAction(event.clientSecret);
  //     if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
  //       Map<String, dynamic> results =
  //           await _callPayEndpointIntentId(paymentIntentId: paymentIntent.id);
  //       if (results['error'] != null) {
  //         emit(state.copyWith(status: PaymentStatus.failure));
  //       } else {
  //         emit(state.copyWith(status: PaymentStatus.success));
  //       }
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(status: PaymentStatus.failure));
  //   }
  // }

 Future<Map<String,dynamic>> _callPayEndPointMethodId(
      {required bool useStripeSdk,
      required String paymentMethodId,
      required String currency,
      required double total}) async {
      Map<String, dynamic> body = {
        'amount': total.toInt().toString(),
        'currency': 'usd',
      };
    final url = Uri.parse(
        'https://api.stripe.com/v1/payment_intents');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer sk_test_51P7EP6Dw8iLZtBO8RsiUsGVeuyt973YOu5PF8QDuql5weWrEFraedgdqZcPtVVkYZsABA1KNG1TNhzfCM3nXNtfl00QLz4v9vF',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body
    );
    try{
      print("pay body1 res:"+ response.toString());
      return json.decode(response.body.toString());
    }catch(e){
       print('Error decoding JSON: $e');
      // Handle decoding errors gracefully
      return {'error': 'Error decoding JSON'};
    }
  }

  // Future<Map<String, dynamic>> _callPayEndpointIntentId(
  //     {required String paymentIntentId}) async {
  //   final url = Uri.parse(
  //       'https://us-central1-virtualfurnish-93c69.cloudfunctions.net/StripePayEndpointIntentId');
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       'paymentIntentId': paymentIntentId,
  //     }),
  //   );
  //   print("pay body2: "+response.body);
  //   return jsonDecode(response.body);
  // }
}
