import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Sold/sold_list_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Screens/master_page.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_alert_dialog.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';
import 'package:virtual_furnish_app/ui/Widgets/secondary_custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/video_player_widget.dart';

class SoldListPage extends StatelessWidget {
  const SoldListPage({super.key,required this.soldListBloc});
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sold List'),
      ),
      body: BlocConsumer<SoldListBloc, SoldListState>(
        listener: (context, state) {
          if (state is DeleteItemSuccess) {
            CustomSnackbar.showSuccessSnackbar(context, 'Item Deleted');
          } else if (state is DeleteItemFail) {
            CustomSnackbar.showFailSnackbar(context, 'Failed to delete item');
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case SoldListFetctedLoading:
              return const Center(child: CircularProgressIndicator());
            case SoldListDataFetchedByNameSuccess:
             SoldListDataFetchedByNameSuccess cuurentState = state as SoldListDataFetchedByNameSuccess;
              return Center(
            child: ListView.builder(
              itemCount: cuurentState.soldListData.length,
              itemBuilder: (BuildContext context, int index) {
                //add into data list
                for (int i = 0; i < cuurentState.soldListData.length; i++) {
                  data.add(Entry(cuurentState.soldListData[i].name.toString(), <Entry>[
                    //array of images
                    Entry("images",<Entry>[
                      if(cuurentState.soldListData[i].video!=null)
                      Entry(cuurentState.soldListData[i].video!.toString()),
                     for(int j=0;j<cuurentState.soldListData[i].images!.length;j++)
                      Entry(cuurentState.soldListData[i].images![j].toString())
                    ]),
                    Entry("Price : RM${cuurentState.soldListData[i].price.toString()}"),
                    Entry("Amount : ${cuurentState.soldListData[i].amount.toString()}"),
                    Entry("Description: ${cuurentState.soldListData[i].description.toString()}"),
                    Entry("Category: ${cuurentState.soldListData[i].category.toString()}"),
                    Entry("Location: ${cuurentState.soldListData[i].location.toString()}"),
                    (cuurentState.soldListData[i].threeDimensionModel!=null)?Entry("3D Model: ${cuurentState.soldListData[i].threeDimensionModel!.toString()}"):Entry("3D Model: Not Available"),
                  ]));
                }
                return EntryItem(data[index], context, soldListBloc, cuurentState.soldListData[index].id.toString());
              },
            ),
          );
            case SoldListFetctedFail:
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
  const EntryItem(this.entry, this.context, this.soldListBloc, this.id);
  final BuildContext context;
  final Entry entry;
  final SoldListBloc soldListBloc;
  final String id;
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
      children: root.children.map<Widget>(_buildChildrenTiles).toList(),
    );
  }

  Widget _buildChildrenTiles(Entry root) {
    if(root.title == "images"){
      debugPrint(root.children.length.toString());
      for(int i=0;i<root.children.length;i++){
        debugPrint('image: ${root.children[i].title}');
      }
    }
    return (root.title == "images")
        ?  CarouselSlider.builder(
          key: PageStorageKey('myScrollable'),
          itemCount: root.children.length, itemBuilder: 
        (context, index, realIndex) {
          return (root.children[index].title.contains(".mp4"))?
          VideoPlayerWidget(videoUrl: root.children[index].title.toString()):Image.network(root.children[index].title.toString(),fit: BoxFit.cover,);}
        , options: 
        CarouselOptions(
          height: 200,
          aspectRatio: 16/9,
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
        )):(root.title.contains("3D Model:"))?
        SecondaryCustomButton(onPressed: (){
          //Navigate to 3D Model Page
          Navigator.pushNamed(context, '/3d_model_viewer',arguments: {"path":root.title.replaceAll("3D Model: ","")});
        }, buttonText: 'View 3D object', isDisabled: false)
        : GestureDetector(
            onTap: () {},
            child: ListTile(
                trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                title: Text(root.title)));
        
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class Entry {
  const Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}
