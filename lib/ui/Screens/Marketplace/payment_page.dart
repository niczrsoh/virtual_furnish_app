import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/payment_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

class PaymentPage extends StatelessWidget {
   PaymentPage({super.key, required this.paymentBloc, required this.cartProducts, required this.totalPayment});
  final PaymentBloc paymentBloc;
  final List<CartProductModel> cartProducts;
  final double totalPayment;
   CardFormEditController cardFormEditController =
                      CardFormEditController(
                          initialDetails: CardFieldInputDetails(
                              number: '4242424242424242',
                              expiryMonth: 12,
                              expiryYear: 25,
                              cvc: '123', complete: true));
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) async {
        paymentBloc.add(PaymentStart());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment Page'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            paymentBloc.add(PaymentStart());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: PaddingStyles.paddingStyle1,
              child: BlocConsumer<PaymentBloc, PaymentState>(
                bloc: paymentBloc,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                 
            
                  switch (state.status) {
                    case PaymentStatus.initial:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Stripe Bank Card Payment (Test Mode)',
                            style: CustomTextStyle.tertiaryTitleText(context),
                          ),
                          const SizedBox(height: 20),
                          CardFormField(
                            controller: cardFormEditController,
                            onCardChanged: (card) {
                            },
                          ),
                          CustomButton(
                              onPressed: () {
                                if(!cardFormEditController.details.complete){
                              
                                  CustomSnackbar.showFailSnackbar(context, 'Please fill in the card details');
                                  return;
                                }
                                paymentBloc.add(PaymentCreateIntent(
                                        total: totalPayment,
                                        billingDetails: BillingDetails(
                                            email: 'sohren@graduate.utm.my'),
                                        items: cartProducts
                                          ));
                              },
                              buttonText: 'Pay',
                              isDisabled: false)
                        ],
                      );
                    case PaymentStatus.loading:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case PaymentStatus.success:
                      return Padding(
                        padding: PaddingStyles.paddingStyle1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: mq.height * 0.05),
                          Image.asset('assets/images/success.png'),
                          SizedBox(height: mq.height * 0.05),
                          Center(child: Text('Payment Success !', style: CustomTextStyle.secondaryTitleText(context))),
                          Center(child: Text('Your order will be delivered soon.', style: CustomTextStyle.tertiaryTitleText(context))),
                          Center(child: Text('Thank you for choosing our app.', style: CustomTextStyle.tertiaryTitleText(context))),
                           SizedBox(height: mq.height * 0.05),
                        //  Expanded(child: SizedBox()),
                          CustomButton(
                              onPressed: () {
                               // paymentBloc.add(PaymentStart());
                                 Navigator.pop(context);
                                 Navigator.pop(context, "success payment");
                                 paymentBloc.add(PaymentStart());
                                // Navigator.pop(context);
                              },
                              buttonText: 'Continue Shopping',
                              isDisabled: false)
                        ]),
                      );
                    case PaymentStatus.failure:
                      return Column(children: [
                        Center(child: Text('Payment Failed')),
                        CustomButton(
                            onPressed: () {
                              paymentBloc.add(PaymentStart());
                            },
                            buttonText: 'Try Again',
                            isDisabled: false)
                      ]);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
