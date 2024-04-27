import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/cart_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/marketplace_bloc.dart';
import 'package:virtual_furnish_app/ui/Screens/AR Space/augmented_reality_space_page.dart';
import 'package:virtual_furnish_app/bloc/Master/master_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/create_selling_item_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/sold_list_bloc.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/cart_product_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/marketplace_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/seller_profile_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/user_profile_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Sold/create_selling_item_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Sold/sold_list_page.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';

List<BottomNavigationBarItem> bottomNavBars = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
  BottomNavigationBarItem(icon: Icon(Icons.trolley), label: 'cart'),
  BottomNavigationBarItem(icon: Icon(Icons.interests), label: 'AR Space'),
  BottomNavigationBarItem(icon: Icon(Icons.message), label: 'message'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
];

List<BottomNavigationBarItem> sellerBottomNavBars =
    const <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.add_card), label: 'sold'),
  BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'order'),
  BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add'),
  BottomNavigationBarItem(icon: Icon(Icons.message), label: 'message'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
];
int tabIndex = 0;
 UserProfileBloc userProfileBloc = UserProfileBloc()..add(UserProfileFetched());
 SellerProfileBloc sellerProfileBloc = SellerProfileBloc();
 CartBloc cartBloc = CartBloc()..add(LoadCart());
 CreateSellingItemBloc createSellingItemBloc = CreateSellingItemBloc();
 SoldListBloc soldListBloc = SoldListBloc()..add(SoldListDataFetched());
 MarketplaceBloc marketplaceBloc = MarketplaceBloc()..add(FetchMostSellingItems());
List<Widget> bottomNavScreen = [
  BlocProvider<MarketplaceBloc>.value(
    value: marketplaceBloc,
    child: MarketplacePage(marketplaceBloc: marketplaceBloc),
  ),
  BlocProvider<CartBloc>.value(
    value: cartBloc,
    child: CartProductPage(cartBloc: cartBloc),
  ),
  ARSpacePage(),
  Text('index 3: message'),
  BlocProvider<UserProfileBloc>.value(
    value: userProfileBloc,
    child: UserProfilePage(userProfileBloc: userProfileBloc),
  )
];
List<Widget> sellerBottomNavScreen = [
  BlocProvider<SoldListBloc>.value(
    value: soldListBloc,
    child: SoldListPage(
      soldListBloc: soldListBloc,
    ),
  ),
  RunningDotsLoader(),
  // Text('index 1: cart'),
  BlocProvider<CreateSellingItemBloc>.value(
    value: createSellingItemBloc,
    child: CreateSellingItemPage(createSellingItemBloc: createSellingItemBloc),
  ),
  Text('index 3: message'),
  BlocProvider<SellerProfileBloc>.value(
    value: sellerProfileBloc,
    child: SellerProfilePage(sellerProfileBloc: sellerProfileBloc),
  )
];

class MasterPage extends StatefulWidget {
  const MasterPage({super.key, required this.bloc});
  final MasterBloc bloc;

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<MasterBloc, MasterState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MasterUserDataFetched || state is MasterTabChanged) {
          if(state.userType != "seller" && state.tabIndex == 0){
            marketplaceBloc.add(FetchMostSellingItems());
          }
          return Scaffold(
            body: Center(
                child: state.userType == "seller"
                    ? sellerBottomNavScreen.elementAt(state.tabIndex)
                    : bottomNavScreen.elementAt(state.tabIndex)),
            bottomNavigationBar: BottomNavigationBar(
              items: state.userType == "seller"
                  ? sellerBottomNavBars
                  : bottomNavBars,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              currentIndex: state.tabIndex,
              onTap: (index) {
                if(state.userType != "seller" && index == 1){
                    cartBloc.add(LoadCart());
                }else if(state.userType != "seller" && index == 4){
                    userProfileBloc.add(UserProfileFetched());}
                   widget.bloc.add(TabChange(tabIndex: index));
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
