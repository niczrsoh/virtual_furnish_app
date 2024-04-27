import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/checkout_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/cart_product_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';

import '../../Widgets/custom_button.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.checkoutBloc});
  final CheckoutBloc checkoutBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Checkout Page'),
        ),
        bottomSheet: 
            Container(
              decoration: BoxDecoration(
                color: CustomColor.primaryBackgroundColor,
              ),
              padding: PaddingStyles.paddingStyle1,
              child: BlocBuilder<CheckoutBloc, CheckoutState>(
                bloc: checkoutBloc,
                buildWhen: (previous, current) => current is CheckoutLoaded,
                builder: (context, state) {
                  if(state is CheckoutInitial) return CircularProgressIndicator();
                  state as CheckoutLoaded;
                  return CustomButton(
                              buttonText: 'Place Order',
                              onPressed: () {
                                //need to pass total amount charged for each shop and the total amount charge to user to the payment page
                                Navigator.pushNamed(context, '/payment', arguments: {'cartProducts': state.cartProducts, 'total': state.totalPayment});},
                                isDisabled: false,
                                    );
                },
              ),
            ),
        body: SingleChildScrollView(
          child: Padding(
            padding: PaddingStyles.paddingStyle1,
            child: BlocConsumer<CheckoutBloc, CheckoutState>(
              bloc: checkoutBloc,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case CheckoutInitial:
                    return Center(child: CircularProgressIndicator());
                  case CheckoutLoading:
                    return Center(child: CircularProgressIndicator());
                  case CheckoutError:
                    return Center(child: Text('Error'));
                  case CheckoutLoaded:
                    final currentState = state as CheckoutLoaded;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: CustomTextStyle.tertiaryTitleText(context),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text('Name'),
                          subtitle: Text('Address'),
                          trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/delivery_address');
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemBuilder: ((context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currentState.checkoutProducts.elementAt(index).sellerName!, style: CustomTextStyle.tertiaryTitleText(context),),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, indexProducts) {
                                      MarketplaceProductModel product = currentState.checkoutProducts.elementAt(index).sellerProducts!.elementAt(indexProducts).keys.elementAt(0);
                                      int amount = currentState.checkoutProducts.elementAt(index).sellerProducts!.elementAt(indexProducts).values.elementAt(0);
                                      return ListTile(
                                        leading: Container(child: Image.network(product.images![0], fit: BoxFit.cover,), width: 50, height: 50),
                                        title: Text(product.name!),
                                        subtitle: Text("RM ${product.price?.toStringAsFixed(2)}"),
                                        trailing: Text("x $amount"),
                                      );
                                    },
                                    itemCount: currentState.checkoutProducts
                                        .elementAt(index).sellerProducts!.length,
                                  ),
                                  ShopPaymentDetail(
                                      title: 'Shipping Fee', value: 2.0),
                                  ShopPaymentDetail(
                                      title: 'Total Payment', value: currentState.checkoutProducts.elementAt(index).totalPayment!),
                                  SizedBox(
                                    height: 10,
                                  )
                                ]);
                          }),
                          itemCount: currentState.checkoutProducts.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Payment Method',
                              style: CustomTextStyle.tertiaryTitleText(context),
                            ),
                            Spacer(),
                            Text(
                              'FPX payment',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        PaymentDetail(
                          title: 'Merchant Subtotal',
                          value: currentState.totalPayment
                        ),
                        PaymentDetail(
                          title: 'Delivery Subtotal',
                          value: currentState.cartProducts.length * 2.0,
                        ),
                        PaymentDetail(
                          title: 'Total Payment',
                          value: currentState.totalPayment + currentState.cartProducts.length * 2.0,
                        ),
                      ],
                    );
                  default:
                    return Container(child: Text('Server Error'));
                }
              },
            ),
          ),
        ));
  }
}

class ShopPaymentDetail extends StatelessWidget {
  const ShopPaymentDetail({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: CustomTextStyle.normalText(context)),
        Spacer(),
        Text(
          'RM ${value.toStringAsFixed(2)}',
          style: CustomTextStyle.normalText(context),
        ),
      ],
    );
  }
}

class PaymentDetail extends StatelessWidget {
  const PaymentDetail({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: (title == "Total Payment")
              ? CustomTextStyle.secondaryTitleText(context)
              : CustomTextStyle.tertiaryTitleText(context),
        ),
        Spacer(),
        Text(
          'RM ${value.toStringAsFixed(2)}',
          style: CustomTextStyle.normalBoldText(context),
        ),
      ],
    );
  }
}
