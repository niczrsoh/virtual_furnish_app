import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/order_detail_bloc.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/order_status_model.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({super.key,  required this.orderBloc});
   final OrderDetailBloc orderBloc;
  final tabs = <Tab>[
    Tab(text: 'To Process'),
    Tab(text: 'To Shipped'),
    Tab(text: 'To Delivered'),
    Tab(text: 'To Receive'),
  ];
  List<Widget> tabPages = <Widget>[
    TabView(type: "process"),
    TabView(type: "shipped"),
   TabView(type: "delivered"),
   TabView(type: "received"),
  ];
  List<String> tabTypes = ['process', 'shipped', 'delivered', 'received'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Detail'),
          bottom: TabBar(
            tabs: tabs,
            onTap: (value) {
              orderBloc.add(FetchOrderByType(tabTypes[value]));
            },
          ),
        ),
        body:  TabBarView(
            children:  tabPages,
          ),
      ),
    );
  }
}

class TabView extends StatelessWidget {
  const TabView({
    super.key,
    required this.type,
  });
  final String type;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      switch(state.runtimeType){
        case OrderDetailInitial:
          return Center(child: RunningDotsLoader());
        case OrderDetailLoading:
          return Center(child: RunningDotsLoader());
        case OrderDetailLoaded:
          final currentState = state as OrderDetailLoaded;
          //return a list of orders
          return ListView.builder(
            itemCount: currentState.orders.length,
            itemBuilder: (context, index) {
              OrderStatus order = currentState.orders[index];
              return ListTile(
                leading: Container(
                  width: 50,
                  //circle image
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(currentState.product_model[index].images![0]??"fail to load image"),
                      fit: BoxFit.cover,
                    ),
                  ),),
                //  child: Image.network(currentState.product_model[index].images![0]??"fail to load image", fit: BoxFit.fitWidth, width: 50, ),),
                title: Text(currentState.product_model[index].name??"fail to load product name"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if((order.trackingNumber!=""&&order.trackingNumber!=null))
                    Text("Tracking No: ${order.trackingNumber}"??"fail to load tracking number"),
                    Text(order.latestTransaction??"fail to load latest transaction"),
                  ],
                ),
              );
            },
          );
        case OrderDetailEmpty:
          return Center(child: Text('No data found'));
        case OrderDetailError:
          final currentState = state as OrderDetailError;
          return Center(child: Text('Error: ${currentState.message}'));
        default:
          return Center(child: Text('Error: Something went wrong'));
      }
    },
);
  }
}
