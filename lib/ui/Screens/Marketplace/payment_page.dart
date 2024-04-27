import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/payment_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key, required this.paymentBloc, required this.cartProducts, required this.totalPayment});
  final PaymentBloc paymentBloc;
  final List<CartProductModel> cartProducts;
  final double totalPayment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          paymentBloc.add(PaymentStart());
        },
        child: Padding(
          padding: PaddingStyles.paddingStyle1,
          child: BlocConsumer<PaymentBloc, PaymentState>(
            bloc: paymentBloc,
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              CardFormEditController cardFormEditController =
                  CardFormEditController(
                      initialDetails: state.cardFieldInputDetails);
        
              switch (state.status) {
                case PaymentStatus.initial:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Card Form',
                        style: CustomTextStyle.primaryTitleText(context),
                      ),
                      const SizedBox(height: 20),
                      CardFormField(
                        controller: cardFormEditController,
                        onCardChanged: (card) {
                          //widget.paymentBloc.add(UpdateCard(card));
                        },
                      ),
                      CustomButton(
                          onPressed: () {
                            (cardFormEditController.details.complete)
                                ? paymentBloc.add(PaymentCreateIntent(
                                    total: totalPayment,
                                    billingDetails: BillingDetails(
                                        email: 'sohren@graduate.utm.my'),
                                    items: cartProducts
                                      ))
                                : CustomSnackbar.showFailSnackbar(
                                    context, 'The form is not complete');
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
                  return Column(children: [
                    Center(child: Text('Payment Success')),
                    CustomButton(
                        onPressed: () {
                         // paymentBloc.add(PaymentStart());
                           Navigator.pop(context);
                           Navigator.pop(context, "success payment");
                          // Navigator.pop(context);
                        },
                        buttonText: 'Continue Shopping',
                        isDisabled: false)
                  ]);
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
    );
  }
}
