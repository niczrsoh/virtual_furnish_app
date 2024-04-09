import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/ui/Screens/AR Space/augmented_reality_space_page.dart';
import 'package:virtual_furnish_app/bloc/Master/master_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/create_selling_item_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/sold_list_bloc.dart';
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
final UserProfileBloc userProfileBloc = UserProfileBloc();
final SellerProfileBloc sellerProfileBloc = SellerProfileBloc();
final CreateSellingItemBloc createSellingItemBloc = CreateSellingItemBloc();
final SoldListBloc soldListBloc = SoldListBloc()..add(SoldListDataFetched());
List userBloc = [
  userProfileBloc,
];
List sellerBloc = [
  sellerProfileBloc,
];
List<Widget> bottomNavScreen = [
  MarketplacePage(),
  Text('index 1: cart'),
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
    child: SoldListPage(soldListBloc: soldListBloc,),
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
          return Scaffold(
            body: Center(
              child: state.userType == "seller"
                      ? sellerBottomNavScreen.elementAt(tabIndex)
                      : bottomNavScreen.elementAt(tabIndex)),
            bottomNavigationBar: BottomNavigationBar(
              items: state.userType == "seller"
                  ? sellerBottomNavBars
                  : bottomNavBars,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              currentIndex: tabIndex,
              onTap: (index) {
                setState(() {
                  tabIndex = index;
                });
             //   widget.bloc.add(TabChange(tabIndex: index));
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
