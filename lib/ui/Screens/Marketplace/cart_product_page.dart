import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/cart_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';
import 'package:virtual_furnish_app/ui/Styles/padding_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';

class CartProductPage extends StatelessWidget {
  CartBloc cartBloc;
  CartProductPage({super.key, required this.cartBloc});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        cartBloc.add(LoadCart());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart Product Page'),
        ),
        bottomSheet: Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0)
              ],
              borderRadius: BorderRadius.circular(12),
              color: CustomColor.primaryBackgroundColor,
            ),
            padding: PaddingStyles.paddingStyle1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //add a checkbox for all
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return Checkbox(
                        value: cartBloc.state.selectedCartProducts?.length ==
                            cartBloc.state.cartProducts?.length,
                        onChanged: (bool? value) {
                          //using bloc to check all
                          if (cartBloc.state.selectedCartProducts!.length !=
                              cartBloc.state.cartProducts!.length) {
                            cartBloc.add(SelectAllCartProduct());
                          } else {
                            cartBloc.add(UnSelectAllCartProduct());
                          }
                        });
                  },
                ),
                Text('All'),
                SizedBox(width: mq.width * 0.05),
                SizedBox(
                  height: mq.height * 0.05,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Amount:'),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          return Text(
                            "RM ${state.totalPrice!.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: CustomColor.priceTagColor,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: mq.width * 0.05),
                BlocConsumer<CartBloc, CartState>(
                  listener: (context, state) {
                    if (state is CartProductSelected || state is CartProductUpdated) {
                      cartBloc.add(CartProductPageButtonPressed());}
                  },
                  builder: (context, state) {
                    bool isButtonDisabled = state is CartProductPageButtonState
                          ? state.isButtonDisabled
                          : true;
                    return CustomButton(
                      width: mq.width * 0.35,
                      buttonText: 'Checkout',
                      isDisabled: isButtonDisabled,
                      onPressed: () {
                        if (!isButtonDisabled) {
                          // Add your code here
                          Navigator.pushNamed(context, '/checkout', arguments: {
                            'cartList': state.selectedCartProducts, 
                          });
                        }
                      },
                    );
                  },
                ),
              ],
            )),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case CartListFetchedSuccess ||
                    CartProductUpdated || 
                    CartProductSelected ||
                    CartProductPageButtonState:
                final currentState;
                if (state is CartListFetchedSuccess) {
                  currentState = state as CartListFetchedSuccess;
                } else if (state is CartProductUpdated) {
                  currentState = state as CartProductUpdated;
                } else if (state is CartProductSelected) {
                  currentState = state as CartProductSelected;
                } else{
                  currentState = state as CartProductPageButtonState;
                }
                return ListView.builder(
                  itemCount: currentState.cartProducts.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      activeColor: CustomColor.vfPrimaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        // Add your code here
                        (currentState.selectedCartProducts
                                .contains(currentState.cartProducts[index]))
                            ? cartBloc.add(UnSelectCartProduct(
                                currentState.cartProducts[index].id!))
                            : cartBloc.add(SelectCartProduct(
                                currentState.cartProducts[index].id!));
                      },
                      value: currentState.selectedCartProducts
                          .contains(currentState.cartProducts[index]),
                      secondary: Image.network(
                        currentState.products[index].images![0],
                        width: mq.width * 0.2,
                        height: mq.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                      title: Text(currentState.products[index].name!),
                      subtitle: Container(
                        width: mq.width * 0.5,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ' +
                                  currentState.products[index].location!),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      // Add your code here
                                      cartBloc.add(UpdateCartProduct(
                                          currentState.cartProducts[index].id!,
                                          currentState
                                                  .cartProducts[index].amount! -
                                              1,
                                          "low"));
                                    },
                                  ),
                                  Text(currentState.cartProducts[index].amount
                                      .toString()),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      // Add your code here
                                      cartBloc.add(UpdateCartProduct(
                                          currentState.cartProducts[index].id!,
                                          currentState
                                                  .cartProducts[index].amount! +
                                              1,
                                          "low"));
                                    },
                                  ),
                                  Flexible(
                                      child: Text(
                                          "RM ${currentState.products[index].price}",
                                          style: TextStyle(
                                              color: CustomColor.priceTagColor,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ]),
                      ),
                    );
                  },
                );
              case CartError:
                final currentState = state as CartError;
                return Center(
                  child: Text(currentState.message),
                );
              default:
                return Center(
                  child: Text('No Product in Cart'),
                );
            }
          },
        ),
      ),
    );
  }
}
