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
        automaticallyImplyLeading: false,
        title: Text('Selling Order Page'),
      ),
      body: RefreshIndicator(
        onRefresh: (){
          sellingOrderBloc.add(FetchItems());
          return Future.value(true);
        },
        child: BlocConsumer<SellingOrderBloc, SellingOrderState>(
              //build when is not action state
              buildWhen: (previous, current) => current is! SellingOrderActionState,
              bloc: sellingOrderBloc,
              listener: (context, state) {
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case SellingOrderInitial:
                    sellingOrderBloc.add(FetchItems());
                    return const Center(child: CircularProgressIndicator());
                  case SellingOrderLoading:
                    sellingOrderBloc.add(FetchItems());
                    return const Center(child: CircularProgressIndicator());
                  case SellingOrderLoaded:
                    data.clear();
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
                                cuurentState.product_model[i].name.toString(),
                                <Entry>[
                                  Entry("Customer Id : ${cuurentState.items[i].customerID.toString()}"),
                                  Entry(
                                      "Amount : ${cuurentState.items[i].amount.toString()}"),
                                  Entry(
                                      "Courier: ${cuurentState.items[i].courier.toString()}"),
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
                  case SellingOrderEmpty:
                    return const Center(child: Text('No order found'));
                  case SellingOrderError:
                    return const Text('Failed to fetch data');
                  default:
                    return const Text('Something went wrong');
                }
              },
            ),
      ),
    );
  }
  
}
class EntryItem extends StatefulWidget {
  const EntryItem(this.entry, this.context, this.sellingOrderBloc, this.id, this.index);
  final BuildContext context;
  final Entry entry;
  final SellingOrderBloc sellingOrderBloc;
  final String id;
  final int index;

  @override
  State<EntryItem> createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    String customerID = root.children[0].title.split(":").last.trim();
    return ExpansionTile(
      maintainState: true,
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: [
        for (int i = 0; i < root.children.length; i++)
          _buildChildrenTiles(root.children[i], widget.index, customerID)
      ]
    );
  }

  Widget _buildChildrenTiles(Entry root, int index, String customerID) {
    String type = root.title.split(':').first;
    String value = root.title.split(':').last.trim();
    return (root.title.contains("Courier:") || root.title.contains("Transaction No") || root.title.contains("Status"))?
     GestureDetector(
                onTap: () {},
                child: BlocConsumer<SellingOrderBloc, SellingOrderState>(
                  bloc: widget.sellingOrderBloc,
                  listener: (previous, current) {
                    if(UpdateOrderItemSuccess == current.runtimeType && (current as UpdateOrderItemSuccess).index == index && (current as UpdateOrderItemSuccess).type == type){
                      value = (current as UpdateOrderItemSuccess).value;
                    }
                  },
                  buildWhen: (previous, current) => current is SellingOrderActionState || current is SellingOrderLoaded,
                  builder: (context, state) {
                    return ListTile(
                        trailing: IconButton(
                            onPressed: () {
                               String type = root.title.split(':').first;
                              if(state is OrderRequestEditSuccess && state.isEdit){
                                 widget.sellingOrderBloc.add(RequestOrderEdit(type: type,isEdit: false, index: index));
                              }else{
                                widget.sellingOrderBloc.add(RequestOrderEdit(type: type,isEdit: true, index: index));}
                            },
                            icon: Icon(Icons.edit)),
                        title: (state is OrderRequestEditSuccess && state.isEdit && state.type == root.title.split(':').first && index == state.index)
                            ? (state.type == "Status")? 
                            //drop down here
                            DropdownButton<String>(
                              value: root.title.split(':').last.trim(),
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                widget.sellingOrderBloc.add(OrderModification(
                                    id: widget.id,
                                    type: state.type,
                                    index: state.index,
                                    value: newValue!,  
                                    customerID: customerID,
                                    ));
                              },
                              items: <String>['process','shipped','cancelled']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                            :TextField(
                                key: PageStorageKey('myScrollable'),
                                controller: TextEditingController(text: root.title.split(':').last.trim()),
                                onSubmitted: (value) {
                                  widget.sellingOrderBloc.add(OrderModification(
                                      id: widget.id,
                                      type: state.type,
                                      index: state.index,
                                      value: value,
                                      customerID: customerID));
                                },
                            ): Text("${type}: ${value}"));
                  },
                ))
    :GestureDetector(
                onTap: () {},
                child: ListTile(
                        title: Text(root.title)
                  ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.entry);
  }}
class Entry {
   Entry(this.title, [this.children = const <Entry>[]]);
  String title;
  final List<Entry> children;
}