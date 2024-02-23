// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/Home/home_bloc.dart';
import 'package:virtual_furnish_app/enums/globalization_enum.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';

//UI
class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
   this.title,
  }) : super(key: key);
  final String? title;
  static HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    homeBloc.add(HomeDataFetched(title: title??""));
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
          leading:  Text(title??"null"),
          title: TextField(
            style: const TextStyle(fontSize: 15),
            decoration:  InputDecoration(
                labelText: 'Search',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black))),
            onSubmitted: (value) {
              homeBloc.add(HomeDataFetchedByTitle(title: value));
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
                height: MediaQuery.of(context).size.height*0.75,
                child: BlocConsumer<HomeBloc, HomeState>(
                  bloc: homeBloc,
                  listener: (context, state) {
                    if (state is HomeDataAddedSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Data Added Successfully'),
                      ));
                    } else if (state is HomeDataAddedFail) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Data Added Failed'),
                      ));
                    }
                  },
                  builder: (context, state) {
                    //listen to state changes to rebuild ui
                    switch (state.runtimeType) {
                      case HomeFetctedLoading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case HomeFetchedSuccess:
                        final successState = state as HomeFetchedSuccess;
                        return ListView.builder(
                            itemCount: successState.homeData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.homeData[index].title),
                                subtitle: Text(state.homeData[index].body),
                              );
                            });
                            
                      case HomeDataFetchedByNameSuccess:
                        final successState = state as HomeDataFetchedByNameSuccess;
                        return ListView.builder(
                            itemCount: successState.homeData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.homeData[index].title),
                                subtitle: Text(state.homeData[index].body),
                              );
                            });
                      default:
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                    }
                
                  },
                ),
              ),
                (View.of(context).viewInsets.bottom > 0) ? SizedBox(height: MediaQuery.of(context).viewInsets.bottom,) : const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
