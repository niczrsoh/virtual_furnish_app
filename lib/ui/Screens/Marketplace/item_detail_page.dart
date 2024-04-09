import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/counter_cubit.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/counter_state.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/item_detail_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/marketplace_page.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';
import 'package:virtual_furnish_app/ui/Styles/padding_styles.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';

class ItemDetailsPage extends StatelessWidget {
  ItemDetailsPage({super.key, this.itemDetail, required this.itemDetailBloc});
  final String? itemDetail;
  final ItemDetailBloc itemDetailBloc;
  int numberOfItems = 1;
  bool isButtonDisabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomSheet: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
            ],
            borderRadius: BorderRadius.circular(12),
            color: CustomColor.primaryBackgroundColor,
          ),
          padding: PaddingStyles.paddingStyle1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SecondaryCustomButton(
                  width: mq.width * 0.4,
                  onPressed: () {},
                  buttonText: 'Chat',
                  isDisabled: isButtonDisabled),
              CustomButton(
                  width: mq.width * 0.4,
                  onPressed: () {},
                  buttonText: 'Buy Now',
                  isDisabled: isButtonDisabled),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<ItemDetailBloc, ItemDetailState>(
            bloc: itemDetailBloc,
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.runtimeType) {
                case ItemDetailFetctedLoading:
                  return const Center(child: CircularProgressIndicator());
                case ItemDetailFetchedSuccess:
                  final currentState = state as ItemDetailFetchedSuccess;
                  return Padding(
                    padding: PaddingStyles.paddingStyle1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider(
                            items: (currentState.itemData.images != null)
                                ? currentState.itemData.images!
                                    .map((image) => Image.network(image))
                                    .toList()
                                : [Image.asset("assets/images/vF_logo.png")],
                            options: CarouselOptions(
                              height: 130,
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              scrollDirection: Axis.horizontal,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: CustomButton(
                              icon: Icons.open_in_new_rounded,
                              radius: 50,
                              width: mq.width * 0.5,
                              buttonText: 'View in AR',
                              isDisabled: isButtonDisabled,
                              onPressed: () {
                                Navigator.pushNamed(context, '/ar_space');
                              },
                            )),
                            Flexible(
                                child: IconButton(
                              icon: Icon(Icons.add_shopping_cart_rounded),
                              onPressed: () {
                                //call bloc that will put the item into cart
                                //show bottom sheet that will show the item added to cart
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return BlocProvider<CounterCubit>(
                                          create: (context) => CounterCubit(),
                                          child: BlocBuilder<CounterCubit,
                                              CounterState>(
                                            builder: (context, state) {
                                              return Container(
                                                padding:
                                                    PaddingStyles.paddingStyle1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                height: mq.height * 0.3,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        "Add ${currentState.itemData.name} to cart ?"),
                                                     SizedBox(height: mq.height * 0.02,),
                                                    Text("Number of items added: "),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      CounterCubit>()
                                                                  .decrement();
                                                            },
                                                            icon: Icon(
                                                                Icons.remove)),
                                                        // Builder(
                                                        //   builder: (context) {
                                                        //     final counterValue = context.select((CounterCubit cubit) => cubit.state.counterValue);
                                                        //     return Text(
                                                        //         '${counterValue}');
                                                        //   }
                                                        // )
                                                        Text(state.counterValue
                                                            .toString()),
                                                        IconButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      CounterCubit>()
                                                                  .increment();
                                                            },
                                                            icon: Icon(
                                                                Icons.add)),
                                                      ],
                                                    ),
                                                      SizedBox(height: mq.height * 0.02,),
                                                    SecondaryCustomButton(
                                                      onPressed: () {
                                                        //will call bloc to add item into cart
                                                        //will show snackbar that item has been added to cart
                                                      //  itemDetailBloc.add(event);
                                                      },
                                                      buttonText:
                                                          'Add into cart',
                                                      isDisabled:
                                                          isButtonDisabled,
                                                      width: mq.width * 0.8,
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ));
                                    });
                              },
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              currentState.itemData.name ?? "no name",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                            Expanded(child: Container()),
                            Flexible(
                                child: Text(
                                    "RM ${currentState.itemData.price!.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: CustomColor.priceTagColor))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(currentState.itemData.description ??
                            "no description"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Payment method'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                                width: mq.width * 0.4,
                                onPressed: () {},
                                buttonText: "Online Banking",
                                isDisabled: isButtonDisabled),
                            CustomButton(
                                width: mq.width * 0.4,
                                onPressed: () {},
                                buttonText: "Touch n Go ewallet",
                                isDisabled: isButtonDisabled),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Seller'),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          leading: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  currentState.userData.profilePic ?? ""),
                            ),
                          ),
                          title: Text(
                              currentState.sellerData.shopName ?? "no shop"),
                          subtitle: Text(
                              currentState.userData.username ?? "no username"),
                        ),
                        Row(
                          children: [
                            itemCard(
                                currentState: currentState,
                                title: 'Sold',
                                subtitle:
                                    '${currentState.itemData.amount} items left',
                                firstNo:
                                    currentState.itemData.buyers!.toDouble()),
                            SizedBox(
                              width: mq.width * 0.2,
                            ),
                            itemCard(
                                currentState: currentState,
                                title: 'Reviews',
                                subtitle: '23 ratings',
                                firstNo: 4.3),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Buyers' Reviews: "),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  );

                default:
                  return const Center(
                      child: Text("Failed to load item details"));
              }
            },
          ),
        ));
  }
}

class itemCard extends StatelessWidget {
  const itemCard({
    super.key,
    required this.currentState,
    required this.title,
    required this.subtitle,
    required this.firstNo,
  });

  final ItemDetailFetchedSuccess currentState;
  final String title;
  final String subtitle;
  final double firstNo;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(title),
        ),
        RichText(
            text: TextSpan(
                text: (title == "Sold") ? "${firstNo.toInt()}" : "$firstNo",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                text: (title == "Sold") ? ' items' : ' /5.0',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ])),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(subtitle),
        ),
      ],
    );
  }
}
