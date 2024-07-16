import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/order_detail_bloc.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/order_status_model.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_loading_bar.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({super.key,  required this.orderBloc});
   final OrderDetailBloc orderBloc;

  List<String> tabTypes = ['process', 'shipped','received','completed'];
  @override
  Widget build(BuildContext context) {
      final tabs = <Tab>[
    Tab(text: 'To Process'),
    Tab(text: 'To Shipped'),
    Tab(text: 'To Receive'),
    Tab(text: 'Completed')
  ];
  List<Widget> tabPages = <Widget>[
    TabView(type: "process", orderBloc: orderBloc,),
    TabView(type: "shipped", orderBloc: orderBloc,),
   TabView(type: "received", orderBloc: orderBloc,),
   TabView(type: "completed", orderBloc: orderBloc,)
  ];
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
            children:  tabPages
           
          ),
      ),
    );
  }
}

class TabView extends StatelessWidget {
   TabView({
    super.key,
    required this.orderBloc,
    required this.type,
  });
   OrderDetailBloc orderBloc;
  final String type;
  bool isButtonDisabled=false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listenWhen: (previous, current) => current is OrderDetailActionState,
      buildWhen: (previous, current) => current is !OrderDetailActionState,
    listener: (context, state) {
      // TODO: implement listener
      if (state is OrderDetailError) {
        CustomSnackbar.showFailSnackbar(context, state.message);
      }
      else if (state is OrderDetailConfirmed) {
        CustomSnackbar.showSuccessSnackbar(context, "Item Confirmed");
      }
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
                    if (order.status!="completed") Text("Tracking No: ${order.trackingNumber}"??"fail to load tracking number"),
                   if (order.status!="completed") Text(order.latestTransaction??"fail to load latest transaction"),
                    (order.status=="received")?Text("Please tap on the order received button after receiving your item"??"fail to load received date"):Container(),
                    // a button for received
                    SizedBox(height: 10),
                    
                    if (order.status=="received")
                    SecondaryCustomButton(
                      isDisabled: isButtonDisabled,
                      buttonText: 'Order Received',
                      onPressed: () {
                        orderBloc.add(ConfirmItem(order.id!));
                      },
                    ),
                    if (order.status=="completed")...[
                      Text("Order Completed \n Please rate the product"),
                      SizedBox(height: 10),
                      Center(
                        child: SecondaryCustomButton(
                        isDisabled: isButtonDisabled,
                        buttonText: 'Rate',
                         width: mq.width*0.3,
                        onPressed: () {
                                             
                        
                        },
                                            ),
                      ),
                    ],
                    
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
