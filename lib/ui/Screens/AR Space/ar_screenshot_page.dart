import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_share/social_share.dart';
import 'package:virtual_furnish_app/bloc/ARSpace/ar_media_bloc.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_button.dart';
import 'package:virtual_furnish_app/ui/Widgets/custom_snackbar.dart';

class ARScreenshotPage extends StatelessWidget {
   ARScreenshotPage({super.key, required this.bloc, required this.image});
  final ArMediaBloc bloc;
  final ImageProvider image;
  File? file;
  bool isButtonDisabled = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
              onPopInvoked: (bool didPop) async {
                if (didPop) {
                  return;
                }
               Navigator.pop(context,"back");
              },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Screenshot'),
        ),
        body: Center(
          child: Column(
            children: [
              Image(
                height: mq.height * 0.8,
                image: image),
              SizedBox(height: 10,),
              BlocListener<ArMediaBloc, ArMediaState>(
                bloc: bloc,
                listenWhen: (previous, current) => current is ArMediaActionState,
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is ArMediaAdded) {
                    isButtonDisabled = false;
                    CustomSnackbar.showSuccessSnackbar(context, "Image Saved");
                    //alert dialog for sharing image via whatsapp
                    showDialog(context: context, builder: (context) => AlertDialog(
                      title: Text("Share Image"),
                      content: Text("Do you want to share your image to social media ?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await SocialShare.shareOptions("Image Saved", imagePath: file!.path);
                            Navigator.pop(context);
                          },
                          child: Text("Yes"),
                        ),
                      ],
                    ));
                  } else if (state is ArMediaError) {
                    isButtonDisabled = false;
                    CustomSnackbar.showFailSnackbar(context, state.message);
                  } 
                },
                child: CustomButton(
                  onPressed: () async {
                    isButtonDisabled = true;
                    CustomSnackbar.showLoadingSnackbar(context, "Saving Image...");
                    file = await _imageToFile(image, context);
                  //  ]ImageConfiguration configuration = createLocalImageConfiguration(context);
                    print("image path: ${file!.path}");
                    bloc.add(ArMediaAdd(image: file!.path, video: null));}
                  ,
                  buttonText: 'Save Image',
                  isDisabled: isButtonDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<File?> _imageToFile(ImageProvider imageProvider, BuildContext context) async {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final ImageConfiguration imageConfiguration = ImageConfiguration(
  devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
  size: renderBox.size,
);
final ImageStream stream = imageProvider.resolve(imageConfiguration);
  final completer = Completer<ImageInfo>();
  ImageStreamListener? listener;
  listener = ImageStreamListener((ImageInfo image, bool syncCall) {
    completer.complete(image);
    stream.removeListener(listener!);
  });
  stream.addListener(listener);
   final ImageInfo imageInfo = await completer.future;
  final ByteData? byteData = await imageInfo.image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  if (byteData == null) {
    return null;
  }
  final Uint8List imageBytes = byteData.buffer.asUint8List();
  final String filePath = '${Directory.systemTemp.path}/${DateTime.now().toIso8601String()}.png';
  final File imageFile = File(filePath);
  await imageFile.writeAsBytes(imageBytes);
  return imageFile;
}
}
  