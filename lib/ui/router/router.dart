import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:virtual_furnish_app/bloc/Authentication/Login/login_bloc.dart';
import 'package:virtual_furnish_app/bloc/Home/home_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/cart_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/checkout_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/counter_cubit.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/item_detail_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/item_list_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/payment_bloc.dart';
import 'package:virtual_furnish_app/bloc/Master/master_bloc.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/selling_order_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/edit_profile_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/seller_register_bloc.dart';
import 'package:virtual_furnish_app/bloc/Profile/bloc/user_profile_bloc.dart';
import 'package:virtual_furnish_app/core/helpers/auth_provider.dart';
import 'package:virtual_furnish_app/data/model/item_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/ui/Screens/AR%20Space/augmented_reality_space_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/login_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/login_phone.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/otp_verification_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/register_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Common/three_dimension_object_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Common/video_player_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Home/home_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/cart_product_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/checkout_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/delivery_addresses_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/item_detail_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/items_list_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/marketplace_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Marketplace/payment_page.dart';
import 'package:virtual_furnish_app/ui/Screens/OrderManagement/selling_order_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/edit_profile_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/seller_register_list.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/seller_registration_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Profile/user_profile_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Sold/create_selling_item_page.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/router/pages_const.dart';
import 'package:virtual_furnish_app/ui/Screens/root_page.dart';

class AppRouter {
  static final HomeBloc homeBloc = HomeBloc()..add(HomeDataFetched(title: ""));
  static final EditProfileBloc editProfileBloc = EditProfileBloc();
  static final MasterBloc masterbloc = MasterBloc();

  static final UserProfileBloc userProfileBloc = UserProfileBloc();
  static final ItemListBloc itemListBloc = ItemListBloc();
  static final CheckoutBloc checkoutBloc = CheckoutBloc();
  static final PaymentBloc paymentBloc = PaymentBloc();
  static final ItemDetailBloc itemDetailBloc = ItemDetailBloc();
  static final CartBloc cartBloc = CartBloc();
  static final AuthenticationProvider authProvider = AuthenticationProvider();
  static final LoginBloc loginBloc = LoginBloc();
  static final SellingOrderBloc sellingOrderBloc = SellingOrderBloc();
  final CounterCubit _counterCubit = CounterCubit();
  static final SellerRegisterBloc sellerRegister = SellerRegisterBloc();
  static Route onGenerateRoute(RouteSettings settings) {
    Map? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case PagePath.pathRoot:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => AuthenticationProvider(),
                    ),
                  ],
                  child: const RootPage(),
                ));
      case PagePath.pathHome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<HomeBloc>.value(
            value: homeBloc,
            child: HomePage(
              title: args?['title'] ?? "",
              homeBloc: homeBloc,
            ),
          ),
        );
      case PagePath.pathLogin:
        return MaterialPageRoute(
            settings: settings, builder: (context) => LoginPage());
      case PagePath.pathRegister:
        return MaterialPageRoute(
            settings: settings, builder: (context) => RegisterPage());
      case PagePath.pathLoginWithPhone:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => PhoneLoginPage(loginBloc: loginBloc));
      case PagePath.pathOtpVerfication:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => OtpVerificationPage(
                loginBloc: loginBloc, verificationId: args?['verificationId']));
      case PagePath.pathEditProfile:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider<EditProfileBloc>.value(
                  value: editProfileBloc
                    ..add(FetchUserProfile(
                        id: AuthRepo.getCurrentUserId() ?? "")),
                  child: EditProfilePage(bloc: editProfileBloc),
                ));
      case PagePath.pathMaster:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider<MasterBloc>.value(
                  value: masterbloc..add(FetchUserData()),
                  child: MasterPage(bloc: masterbloc),
                ));
      case PagePath.pathSellerRegisterList:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => BlocProvider<SellerRegisterBloc>.value(
                  value: sellerRegister..add(SellerRegisterFetchList()),
                  child: SellerRegisterList(sellerRegisterBloc: sellerRegister),
                ));
      case PagePath.pathSellerRegister:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => MultiProvider(
                  providers: [
                    BlocProvider<SellerRegisterBloc>.value(
                      value: sellerRegister,
                    ),
                    ChangeNotifierProvider<AuthenticationProvider>.value(
                      value: authProvider,
                    ),
                  ],
                  child: SellerRegistrationPage(bloc: sellerRegister),
                ));
      case PagePath.pathVideoPlayer:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => VideoPlayerScreen(
                uri: args?['uri'], videoFile: args?['videoFile']));
      // case PagePath.pathMarketplace:
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (_) =>  MarketplacePage(),
      //   );
      case PagePath.pathItemList:
        if (args?['title'] != null) {
          itemListBloc.add(ItemListFetchedByTitle(title: args?['title']));
        } else {
          itemListBloc
              .add(ItemListFetchedByCategory(category: args?['category']));
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<ItemListBloc>.value(
            value: itemListBloc,
            child: ItemsListPage(
              itemsListBloc: itemListBloc,
              title: args?['title'],
              category: args?['category'],
            ),
          ),
        );
      case PagePath.pathItemDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ItemDetailBloc>.value(
                value: itemDetailBloc..add(ItemDetailFetched(id: args?['id'])),
              ),
              BlocProvider<CartBloc>.value(
                value: cartBloc,
              ),
            ],
            child: ItemDetailsPage(
                itemDetailBloc: itemDetailBloc, cartBloc: cartBloc),
          ),
        );
      case PagePath.path3DModelViewer:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ThreeDimensionObjectPage(
            objectPath: args?['path'],
          ),
        );
      case PagePath.pathARSpace:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ARSpacePage(
            itemId: args?["itemId"],
          ),
        );
      case PagePath.pathCart:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<CartBloc>.value(
            value: cartBloc,
            child: CartProductPage(cartBloc: cartBloc),
          ),
        );
      case PagePath.pathPayment:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<PaymentBloc>.value(
            value: paymentBloc,
            child: PaymentPage(paymentBloc: paymentBloc, cartProducts: args?['cartProducts'], totalPayment: args?['total']),
          ),
        );
      case PagePath.pathDeliveryAddress:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DeliveryAddressesPage(),
        );
      case PagePath.pathCheckout:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<CheckoutBloc>.value(
            value: checkoutBloc
              ..add(LoadCheckout(cartProducts: args?['cartList'])),
            child: CheckoutPage(checkoutBloc: checkoutBloc),
          ),
        );
      case PagePath.pathSellingOrder:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<SellingOrderBloc>.value(
            value: sellingOrderBloc..add(FetchItems()),
            child: SellingOrderPage(sellingOrderBloc: sellingOrderBloc,),
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RootPage(),
        );
    }
  }
}
