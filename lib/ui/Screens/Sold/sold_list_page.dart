import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/OrderManagement/selling_order_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/sold_list_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_alert_dialog.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/video_player_widget.dart';

class SoldListPage extends StatelessWidget {
  const SoldListPage({super.key, required this.soldListBloc});
  final SoldListBloc soldListBloc;
  static final List<Entry> data = [];
  // <Entry>[
  //   Entry(
  //     "Item Name",
  //     <Entry>[
  //       Entry(
  //           "https://compote.slate.com/images/22ce4663-4205-4345-8489-bc914da1f272.jpeg?crop=1560%2C1040%2Cx0%2Cy0"),
  //       Entry("Section A0"),
  //       Entry("Section A1"),
  //       Entry("Section A2"),
  //     ],
  //   ),
  //   Entry(
  //     "Chapter B",
  //     <Entry>[
  //       Entry(
  //           "https://compote.slate.com/images/22ce4663-4205-4345-8489-bc914da1f272.jpeg?crop=1560%2C1040%2Cx0%2Cy0"),
  //       Entry("Section B0"),
  //       Entry("Section B1"),
  //     ],
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        data.clear();
        soldListBloc.add(SoldListDataFetched());
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Sold List'),
          ),
          body: BlocConsumer<SoldListBloc, SoldListState>(
            //build when is not action state
            buildWhen: (previous, current) => current is! SoldListActionState && current is! SoldListConditionState,
            //listener when is action state
            listenWhen: (previous, current) => current is SoldListActionState,
            bloc: soldListBloc,
            listener: (context, state) {
              if (state is DeleteItemSuccess) {
                Navigator.pop(context);
                CustomSnackbar.showSuccessSnackbar(context, 'Item Deleted');
              } else if (state is DeleteItemFail) {
                Navigator.pop(context);
                CustomSnackbar.showFailSnackbar(context, 'Failed to delete item');
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
                case SoldListInitial:
                  soldListBloc.add(SoldListDataFetched());
                  return const Center(child: CircularProgressIndicator());
                case SoldListFetctedLoading:
                  return const Center(child: CircularProgressIndicator());
                case SoldListDataFetchedByNameSuccess:
                  data.clear();
                  SoldListDataFetchedByNameSuccess cuurentState =
                      state as SoldListDataFetchedByNameSuccess;
                  return Center(
                    child: ListView.builder(
                      itemCount: cuurentState.soldListData.length,
                      itemBuilder: (BuildContext context, int index) {
                        //add into data list
                        for (int i = 0;
                            i < cuurentState.soldListData.length;
                            i++) {
                          data.add(Entry(
                              cuurentState.soldListData[i].name.toString(),
                              <Entry>[
                                //array of images
                                Entry("images", <Entry>[
                                  if (cuurentState.soldListData[i].video != null)
                                    Entry(cuurentState.soldListData[i].video!
                                        .toString()),
                                  for (int j = 0;
                                      j <
                                          cuurentState
                                              .soldListData[i].images!.length;
                                      j++)
                                    Entry(cuurentState.soldListData[i].images![j]
                                        .toString())
                                ]),
                                Entry(
                                    "Price : RM${cuurentState.soldListData[i].price.toString()}"),
                                Entry(
                                    "Amount : ${cuurentState.soldListData[i].amount.toString()}"),
                                Entry(
                                    "Description: ${cuurentState.soldListData[i].description.toString()}"),
                                Entry(
                                    "Category: ${cuurentState.soldListData[i].category.toString()}"),
                                Entry(
                                    "Location: ${cuurentState.soldListData[i].location.toString()}"),
                                (cuurentState.soldListData[i]
                                            .threeDimensionModel !=
                                        null)
                                    ? Entry(
                                        "3D Model: ${cuurentState.soldListData[i].threeDimensionModel!.toString()}")
                                    : Entry("3D Model: Not Available"),
                              ]));
                        }
                        return EntryItem(data[index], context, soldListBloc,
                            cuurentState.soldListData[index].id.toString(), index);
                      },
                    ),
                  );
                case SoldListFetchedSuccessEmpty:
                  return const Center(child: Text('No selling items found \n Try adding new selling items', textAlign: TextAlign.center));  
                case SoldListFetctedFail:
                  return Center(child: const Text('Failed to fetch data'));
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.context, this.soldListBloc, this.id, this.index);
  final BuildContext context;
  final Entry entry;
  final SoldListBloc soldListBloc;
  final String id;
  final int index;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      trailing: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    title: "Delete",
                    message: "Are you sure you want to delete?",
                    confirmButtonText: "Yes",
                    cancelButtonText: "No",
                    confirmButtonPressed: () {
                      soldListBloc.add(DeleteItem(id: id));
                    },
                    cancelButtonPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          },
          icon: Icon(Icons.delete)),
      children: [
        for (int i = 0; i < root.children.length; i++)
          _buildChildrenTiles(root.children[i], index)
      ]
    );
  }

  Widget _buildChildrenTiles(Entry root, int index) {
    if (root.title == "images") {
      debugPrint(root.children.length.toString());
      for (int i = 0; i < root.children.length; i++) {
        debugPrint('image: ${root.children[i].title}');
      }
    }
    String type = root.title.split(':').first;
    String value = root.title.split(':').last.trim();
    return (root.title == "images")
        ? CarouselSlider.builder(
            key: PageStorageKey('myScrollable'),
            itemCount: root.children.length,
            itemBuilder: (context, index, realIndex) {
              return (root.children[index].title.contains(".mp4"))
                  ? VideoPlayerWidget(
                      videoUrl: root.children[index].title.toString())
                  : Image.network(
                      root.children[index].title.toString(),
                      fit: BoxFit.cover,
                    );
            },
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ))
        : (root.title.contains("3D Model:"))
            ? SecondaryCustomButton(
                onPressed: () {
                  //Navigate to 3D Model Page
                  Navigator.pushNamed(context, '/3d_model_viewer', arguments: {
                    "path": root.title.replaceAll("3D Model: ", "")
                  });
                },
                buttonText: 'View 3D object',
                isDisabled: false)
            : GestureDetector(
                onTap: () {},
                child: BlocConsumer<SoldListBloc, SoldListState>(
                  bloc: soldListBloc,
                  buildWhen: (previous, current) => current is RequestEditSuccess || current is UpdateItemSuccess,
                  listener: (current, state) {
                     if(state is UpdateItemSuccess && root.title.split(":").first == state.type && index == state.index){
                      value = state.value;
                      }
                  },
                  builder: (context, state) {
                    return ListTile(
                        trailing: IconButton(
                            onPressed: () {
                               String type = root.title.split(':').first;
                              if(state is RequestEditSuccess && state.isEdit){
                                 soldListBloc.add(RequestEdit(type: type,isEdit: false, index: index));
                              }else{
                              soldListBloc.add(RequestEdit(type: type,isEdit: true, index: index));}
                            },
                            icon: Icon(Icons.edit)),
                        title: (state is RequestEditSuccess && state.isEdit && state.type == root.title.split(':').first && index == state.index)
                            ? TextField(
                                key: PageStorageKey('myScrollable'),
                                decoration: InputDecoration(
                                  prefixIcon: (state.type=="Price")?Text("RM "):null,
                                  hintText: root.title.split(':').last,
                                ),
                                onSubmitted: (value) {
                                  soldListBloc.add(ProductModification(
                                      id: id,
                                      type: state.type,
                                      index: state.index,
                                      value: value));
                                },
                                
                            ): Text("${type}: ${value}"));
                  },
                ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class Entry {
   Entry(this.title, [this.children = const <Entry>[]]);
  String title;
  final List<Entry> children;
}
