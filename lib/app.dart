import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Screens/empty_page.dart';
import 'package:virtual_furnish_app/ui/Styles/color_styles.dart';
import 'package:virtual_furnish_app/ui/router/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
final GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
 
  @override
  Widget build(BuildContext context) {
    //Specifies the set of orientations the application interface can be displayed in.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Virtual Furnish',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColor.primaryBackgroundColor,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          
        ),
        focusColor: CustomColor.vfPrimaryColor,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor:
                CustomColor.vfPrimaryColor, // Change cursor color here
          ),
          scaffoldBackgroundColor: CustomColor.primaryBackgroundColor,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: CustomColor.primaryBackgroundColor,
            filled: true,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: CustomColor.vfPrimaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
        primaryColor: MaterialColor(
          CustomColor.vfPrimaryColor.value,
          <int, Color>{
            50: CustomColor.vfPrimaryColor,
            100: CustomColor.vfPrimaryColor,
            200: CustomColor.vfPrimaryColor,
            300: CustomColor.vfPrimaryColor,
            400: CustomColor.vfPrimaryColor,
            500: CustomColor.vfPrimaryColor,
            600: CustomColor.vfPrimaryColor,
            700: CustomColor.vfPrimaryColor,
            800: CustomColor.vfPrimaryColor,
            900: CustomColor.vfPrimaryColor,
          },
        ),
      ),
      navigatorKey: navigatorKey,
      supportedLocales: const [
         Locale('en', 'IN'), // English
         Locale('zh', 'IN')
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
      onUnknownRoute: (setting) => MaterialPageRoute(
        builder: (_) => const EmptyPage(),
        ),
    );
  }
}
