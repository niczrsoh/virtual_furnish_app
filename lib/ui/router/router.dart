import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Authentication/bloc/login_bloc.dart';
import 'package:virtual_furnish_app/bloc/Home/home_bloc.dart';
import 'package:virtual_furnish_app/bloc/Master/bloc/master_bloc.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/login_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/login_phone.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/otp_verification_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/register_page.dart';
import 'package:virtual_furnish_app/ui/Screens/Home/home_page.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/router/pages_const.dart';
import 'package:virtual_furnish_app/ui/Screens/root_page.dart';

class AppRouter {
  static final homeBloc = HomeBloc();
  static Route onGenerateRoute(RouteSettings settings) {
    Map? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case PagePath.pathRoot:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RootPage(),
        );
      case PagePath.pathHome:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomePage(title: args?['title'] ?? ""),
        );
      case PagePath.pathLogin:
        return MaterialPageRoute(
            settings: settings, builder: (context) => LoginPage());
      case PagePath.pathRegister:
        return MaterialPageRoute(
            settings: settings, builder: (context) => RegisterPage());
      case PagePath.pathLoginWithPhone:
        return MaterialPageRoute(
            settings: settings, builder: (context) => PhoneLoginPage());
      case PagePath.pathOtpVerfication:
        return MaterialPageRoute(
            settings: settings, builder: (context) => OtpVerificationPage());
      case PagePath.pathMaster:
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => MasterPage());
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RootPage(),
        );
    }
  }
}
