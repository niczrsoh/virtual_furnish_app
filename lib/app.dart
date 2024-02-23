import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Screens/empty_page.dart';
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
        primarySwatch: Colors.blue,
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
