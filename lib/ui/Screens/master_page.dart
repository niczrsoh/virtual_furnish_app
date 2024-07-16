import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/ARSpace/ar_media_bloc.dart';
import 'package:virtual_furnish_app/bloc/ChatAndNotification/manage_messages_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/cart_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/marketplace_bloc.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/selling_order_bloc.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/ui/Screens/AR Space/augmented_reality_space_page.dart';
import 'package:virtual_furnish_app/bloc/Master/master_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/create_selling_item_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/sold_list_bloc.dart';
import 'package:virtual_furnish_app/ui/Screens/AR%20Space/ar_flutter_page.dart';
import 'package:virtual_furnish_app/ui/Screens/AR%20Space/ar_video_image_page.dart';
import 'package:virtual_furnish_app/ui/Screens/ChatAndNotification/chat_list_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/cart_product_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/marketplace_page.dart';
import 'package:virtual_furnish_app/ui/Screens/OrderManagement/selling_order_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/seller_profile_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/user_profile_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Sold/create_selling_item_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Sold/sold_list_page.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';
import 'package:virtual_furnish_app/ui/router/router.dart';

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
CreateSellingItemBloc createSellingItemBloc = CreateSellingItemBloc();
SellingOrderBloc sellingOrderBloc = SellingOrderBloc()..add(FetchItems());
SoldListBloc soldListBloc = SoldListBloc()..add(SoldListDataFetched());
ArMediaBloc arMediabloc = ArMediaBloc()..add(ArMediaLoad());
MarketplaceBloc marketplaceBloc = MarketplaceBloc()
  ..add(FetchMostSellingItems());
List<Widget> bottomNavScreen = [
  BlocProvider<MarketplaceBloc>.value(
    value: marketplaceBloc,
    child: MarketplacePage(marketplaceBloc: marketplaceBloc),
  ),
  BlocProvider<CartBloc>.value(
    value: AppRouter.cartBloc..add(LoadCart()),
    child: CartProductPage(cartBloc: AppRouter.cartBloc),
  ),
  //RemoteObject(),
  BlocProvider<ArMediaBloc>.value(
    value: arMediabloc,
    child: ARVideoImagesPage(bloc: arMediabloc),
  ),
  //ARSpacePage(),
  BlocProvider<ManageMessagesBloc>.value(
    value: AppRouter.manageMessagesBloc..add(FetchChatRoomListEvent()),
    child: ChatListPage(bloc: AppRouter.manageMessagesBloc),
  ),
  BlocProvider<UserProfileBloc>.value(
    value: userProfileBloc,
    child: UserProfilePage(userProfileBloc: userProfileBloc),
  )
];
List<Widget> sellerBottomNavScreen = [
  BlocProvider<SoldListBloc>.value(
    value: soldListBloc..add(SoldListDataFetched()),
    child: SoldListPage(
      soldListBloc: soldListBloc,
    ),
  ),
  BlocProvider<SellingOrderBloc>.value(
    value: sellingOrderBloc,
    child: SellingOrderPage(sellingOrderBloc: sellingOrderBloc),
  ),
  // Text('index 1: cart'),
  BlocProvider<CreateSellingItemBloc>.value(
    value: createSellingItemBloc,
    child: CreateSellingItemPage(createSellingItemBloc: createSellingItemBloc),
  ),
  BlocProvider<ManageMessagesBloc>.value(
    value: AppRouter.manageMessagesBloc..add(FetchChatRoomListEvent()),
    child: ChatListPage(bloc: AppRouter.manageMessagesBloc),
  ),
  BlocProvider<SellerProfileBloc>.value(
    value: sellerProfileBloc..add(SellerProfileSearch()),
    child: SellerProfilePage(sellerProfileBloc: sellerProfileBloc),
  )
];

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  late String userType;
  bool foundUserType = false;
  @override
  void initState() {
    getSeller();
    super.initState();
  }

  void getSeller() async {
    bool isGuest = AuthRepo.isGuest();
    if(isGuest){
    setState(() {
      userType = "user";
      foundUserType = true;
    });
    }else{
    userType = await SellerRepo.isSeller(AuthRepo.getCurrentUserId()!);
    if (userType != null && userType.isNotEmpty) {
      setState(() {
        userType = userType;
        foundUserType = true;
      });
    }}
  }

  @override
  Widget build(BuildContext context) {
    return (foundUserType)
        ? Scaffold(
            body: Center(
                child: userType == "seller"
                    ? sellerBottomNavScreen.elementAt(tabIndex)
                    : bottomNavScreen.elementAt(tabIndex)),
            bottomNavigationBar: BottomNavigationBar(
              items: userType == "seller" ? sellerBottomNavBars : bottomNavBars,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              currentIndex: tabIndex,
              onTap: (index) {
                print("index: $index");
                if (userType == "seller") {
                  if (index == 0) {
                    soldListBloc.add(SoldListDataFetched());
                  } else if (index == 1) {
                    sellingOrderBloc.add(FetchItems());
                  } else if (index == 4){
                    sellerProfileBloc.add(SellerProfileSearch());
                  }
                }
                if (userType == "user") {
                  if (index == 0) {
                    marketplaceBloc.add(FetchMostSellingItems());
                  } else if (index == 1) {
                    AppRouter.cartBloc.add(LoadCart());
                  } else if (index == 2) {
                    arMediabloc.add(ArMediaLoad());
                  } else if (index == 3) {
                    AppRouter.manageMessagesBloc.add(FetchChatRoomListEvent());
                  } else if (index == 4) {
                    userProfileBloc.add(UserProfileFetched());
                  }
                }
                if (index == 3) {
                  AppRouter.manageMessagesBloc.add(FetchChatRoomListEvent());
                }
                setState(() {
                  tabIndex = index;
                });
              },
            ),
          )
        : Center(child: RunningDotsLoader());
  }
}
