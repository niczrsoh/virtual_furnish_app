import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Master/bloc/master_bloc.dart';

List<BottomNavigationBarItem> bottomNavBars = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'home'
  ),
    BottomNavigationBarItem(
    icon: Icon(Icons.trolley),
    label: 'cart'
  ),
    BottomNavigationBarItem(
    icon: Icon(Icons.interests),
    label: 'AR Space'
  ),
    BottomNavigationBarItem(
    icon: Icon(Icons.message),
    label: 'message'
  ),
    BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'profile'
  ),
];

const List<Widget> bottomNavScreen = [
  Text('index 0: home'),
  Text('index 1: cart'),
  Text('index 2: ar space'),
  Text('index 3: message'),
  Text('index 4: profile'),
];
class MasterPage extends StatelessWidget {
   MasterPage({super.key});
   final MasterBloc masterbloc = MasterBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MasterBloc,MasterState>(
      bloc: masterbloc,
      listener: (context, state){
        
      },
      builder: (context, state){
        return Scaffold(
          body: Center(child: bottomNavScreen.elementAt(state.tabIndex),),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavBars,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            currentIndex: state.tabIndex,
            onTap: (index){
              masterbloc.add(TabChange(tabIndex: index));
            },
          ),
        );
      }, 
      );
  }
}