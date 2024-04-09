import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/item_list_bloc.dart';
import 'package:virtual_furnish_app/enums/item_category.dart';
import 'package:virtual_furnish_app/main.dart';

class ItemsListPage extends StatelessWidget {
  const ItemsListPage(
      {super.key, this.title, this.category, required this.itemsListBloc});
  final String? title;
  final String? category;
  final ItemListBloc itemsListBloc;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (isPop) {
        FocusScopeNode focusNode = FocusScope.of(context);
        if (focusNode.hasFocus) {
          focusNode.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextField(
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: title ?? category ?? "",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
            onSubmitted: (value) {
              itemsListBloc.add(ItemListFetchedByTitle(title: value));
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AddPage(bloc: homeBloc)));
        //   },
        //   child: const Icon(Icons.add),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: BlocConsumer<ItemListBloc, ItemListState>(
                  bloc: itemsListBloc,
                  listener: (context, state) {},
                  builder: (context, state) {
                    //listen to state changes to rebuild ui
                    switch (state.runtimeType) {
                      case ItemListFetctedLoading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ItemListFetchedSuccess:
                        final successState = state as ItemListFetchedSuccess;
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: successState.itemData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap:(){
                                  debugPrint("id: ${successState.itemData[index].id}");
                                  Navigator.pushNamed(context, "/item_detail", arguments: {"id": successState.itemData[index].id});
                                },
                                child: GridTile(
                                    child: Column(
                                  children: [
                                    Image.network(
                                      successState.itemData[index].images?[0] ??
                                          '',
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                                    Text(successState.itemData[index].name ?? ''),
                                    Text(successState
                                            .itemData[index].description ??
                                        ''),
                                  ],
                                )),
                              );
                            });

                      case ItemListFetchedByNameSuccess:
                        final successState =
                            state as ItemListFetchedByNameSuccess;
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: successState.itemData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap:(){
                                  debugPrint("id: ${successState.itemData[index].id}");
                                  Navigator.pushNamed(context, "/item_detail", arguments: {"id": successState.itemData[index].id});
                                },
                                child: GridTile(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.05, vertical: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        successState.itemData[index].images?[0] ??
                                            '',
                                        fit: BoxFit.cover,
                                        width: mq.width * 0.4,
                                        height: mq.height * 0.2,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        successState.itemData[index].name ?? '',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "RM: ${successState.itemData[index].price}",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )),
                              );
                            });
                      default:
                        return const Center(
                          child: Text('No items found'),
                        );
                    }
                  },
                ),
              ),
              (View.of(context).viewInsets.bottom > 0)
                  ? SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    )
                  : const SizedBox(
                      height: 10,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
