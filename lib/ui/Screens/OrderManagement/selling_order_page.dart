import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/selling_order_bloc.dart';
import 'package:virtual_furnish_app/ui/Widgets/video_player_widget.dart';

class SellingOrderPage extends StatelessWidget {
  const SellingOrderPage({super.key, required this.sellingOrderBloc}) ;
  final SellingOrderBloc sellingOrderBloc;
    static final List<Entry> data = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selling Order Page'),
      ),
      body: BlocConsumer<SellingOrderBloc, SellingOrderState>(
            //build when is not action state
            buildWhen: (previous, current) => current is! SellingOrderActionState,
            //listener when is action state
            listenWhen: (previous, current) => current is SellingOrderActionState,
            bloc: sellingOrderBloc,
            listener: (context, state) {
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case SellingOrderInitial:
                  return const Center(child: CircularProgressIndicator());
                case SellingOrderLoaded:
                  SellingOrderLoaded cuurentState =
                      state as SellingOrderLoaded;
                  return Center(
                    child: ListView.builder(
                      itemCount: cuurentState.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        //add into data list
                        for (int i = 0;
                            i < cuurentState.items.length;
                            i++) {
                          data.add(Entry(
                              cuurentState.items[i].productID.toString(),
                              <Entry>[
                               
                                Entry(
                                    "Customer Id : RM${cuurentState.items[i].customerID.toString()}"),
                                Entry(
                                    "Amount : ${cuurentState.items[i].amount.toString()}"),
                                Entry(
                                    "Courier Service: ${cuurentState.items[i].courier.toString()}"),
                                Entry(
                                    "Transaction No: ${cuurentState.items[i].transactionNumber.toString()}"),
                                Entry(
                                    "Status: ${cuurentState.items[i].status.toString()}"),
                              ]));
                        }
                        return EntryItem(data[index], context, sellingOrderBloc,
                            cuurentState.items[index].id.toString(), index);
                      },
                    ),
                  );
                case SellingOrderError:
                  return const Text('Failed to fetch data');
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
    );
  }
  
}
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.context, this.sellingOrderBloc, this.id, this.index);
  final BuildContext context;
  final Entry entry;
  final SellingOrderBloc sellingOrderBloc;
  final String id;
  final int index;
  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: [
        for (int i = 0; i < root.children.length; i++)
          _buildChildrenTiles(root.children[i], index)
      ]
    );
  }

  Widget _buildChildrenTiles(Entry root, int index) {
    return GestureDetector(
                onTap: () {},
                child:  ListTile(
                        title: Text(root.title)
                  ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }}
class Entry {
  const Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}