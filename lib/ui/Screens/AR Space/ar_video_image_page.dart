import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/ARSpace/ar_media_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Screens/Common/full_screen_page.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';

class ARVideoImagesPage extends StatelessWidget {
  const ARVideoImagesPage({super.key, required this.bloc});
  final ArMediaBloc bloc;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(ArMediaLoad());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AR Video Images'),
        ),
        body: Center(
          child: BlocConsumer<ArMediaBloc, ArMediaState>(
            bloc: bloc,
            listener: (context, state) {
              // TODO: implement listener
            },
            buildWhen: (previous, current) => current is! ArMediaActionState,
            builder: (context, state) {
              switch (state.runtimeType) {
                case ArMediaFromGuest:
                  return const Center(
                    child: Text("Please login to save your AR media!"),
                  );
                case ArMediaInitial:
                  return const Center(child: CircularProgressIndicator());
                case ArMediaLoaded:
                  final currentState = state as ArMediaLoaded;
                  return ListView.separated(
                    padding: PaddingStyles.paddingStyle3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 0),
                    itemCount: currentState.arMediaList.length,
                    itemBuilder: (context, index) {
                      int no = index + 1;
                      return MediaQuery.removePadding(
                        context: context,
                        child: ListTile(
                          visualDensity: VisualDensity.compact,
                          leading: Text(no.toString()),
                          title: Transform.rotate(
                              angle: -90 * pi / 180,
                              child: Image.network(
                                currentState.arMediaList[index].image!,
                                height: mq.width * 0.6,
                              )),
                          subtitle: currentState.arMediaList[index].time != null
                              ? Text(currentState.arMediaList[index].time!
                                  .toDate()
                                  .toString()
                                  .split(".")
                                  .first)
                              : const Text(""),
                          onTap: () {
                            //logic for playing the video or displaying the image
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomFullScreen(
                                  image: NetworkImage(
                                      currentState.arMediaList[index].image!),
                                  tag: currentState.arMediaList[index].image!,
                                  height: mq.height * 0.6,
                                  width: mq.width * 0.6,
                                  revert: true,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                case ArMediaError:
                  final currentState = state as ArMediaError;
                  return Center(child: Text(currentState.message));
                case ArMediaLoading:
                  return const Center(child: CircularProgressIndicator());
                case ArMediaEmpty:
                  return const Center(child: Text("No Media Found"));
                default:
                  return const Center(child: Text("Something went wrong"));
              }
            },
          ),
        ),
      ),
    );
  }
}
