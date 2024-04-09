import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Master/master_bloc.dart';
import 'package:virtual_furnish_app/data/source/view_items_source.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/login_page.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/router/router.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    ViewItemsSource().getRawItems();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            MasterBloc bloc = MasterBloc();
            return BlocProvider<MasterBloc>.value(
                  value: bloc..add(FetchUserData()),
                  child: MasterPage(bloc: bloc),
                );
          }else{
            return LoginPage();
          }
        },
      )
    );
  }
}