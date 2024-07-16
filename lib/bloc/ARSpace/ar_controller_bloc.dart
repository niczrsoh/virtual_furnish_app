import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/ARSpace/ar_sapce_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';
part 'ar_controller_event.dart';
part 'ar_controller_state.dart';

class ArControllerBloc extends Bloc<ArControllerEvent, ArControllerState> {
  ArControllerBloc() : super(ArControllerInitial()) {
    on<ArControllerLoad>(arControllerLoad);
    on<ArControllerAnalyseObject>(arControllerAnalyseObject);
    on<ArControllerLoadSubsequentModels>(arControllerLoadSubsequentModels);
  }

  FutureOr<void> arControllerAnalyseObject(ArControllerAnalyseObject event, Emitter<ArControllerState> emit) async {
    try {
      emit(ArControllerActionLoading());
      List<MarketplaceProductModel> suggestedProduct = await ArSpaceRepo.getSuggestedProduct(event.category);
      emit(ArControllerSuccessFetchedProducts(suggestedProduct));
    } catch (e) {
      emit(ArControllerFailureFetchedProducts(e.toString()));
    }
  }

  FutureOr<void> arControllerLoad(ArControllerLoad event, Emitter<ArControllerState> emit) async {
    emit(ArControllerLoading());
    try {
      String itemID = event.itemId;
      MarketplaceProductModel model = await MarketplaceRepo.getSellingItem(itemID);
      String url = model.threeDimensionModel!;
      String? fileType;
      if (url.contains('.glb')) {
        fileType = 'glb';
      } else if (url.contains('.gltf')) {
        fileType = 'gltf';
      }
      String filename = model.name!;
      HttpClient httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      debugPrint(
          "converts the response body of an [HttpClientResponse] into a [Uint8List].");
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      //new directory
      Directory newDir = Directory('$dir/$itemID');
      await newDir.create(recursive: true);
      // Create the file in the new directory
      File file = File('${newDir.path}/$filename');
      debugPrint("writing to file: ${file.path}");
      await file.writeAsBytes(bytes);
      debugPrint("Downloading finished, path: " + '$dir/$filename');
      if(fileType == null) throw Exception('File type not supported');
      emit(ArControllerSuccessDownloadModel(itemID: itemID, filename: filename, category: model.category!, fileType: fileType!));
    } catch (e) {
      debugPrint('Error downloading file: $e');
      // Handle the error appropriately, e.g., show an error message, retry, etc.
    }
  }

  FutureOr<void> arControllerLoadSubsequentModels(ArControllerLoadSubsequentModels event, Emitter<ArControllerState> emit) async {
   try {
      emit(ArControllerLoadingSubsequentModels());
      String itemID = event.itemId;
      MarketplaceProductModel model = await MarketplaceRepo.getSellingItem(itemID);
      String url = model.threeDimensionModel!;
      String filename = model.name!;
      HttpClient httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      debugPrint(
          "converts the response body of an [HttpClientResponse] into a [Uint8List].");
      var bytes = await consolidateHttpClientResponseBytes(response);
      String dir = (await getApplicationDocumentsDirectory()).path;
      //new directory
      Directory newDir = Directory('$dir/$itemID');
      await newDir.create(recursive: true);
      // Create the file in the new directory
      File file = File('${newDir.path}/$filename');
      debugPrint("writing to file: ${file.path}");
      await file.writeAsBytes(bytes);
      debugPrint("Downloading finished, path: " + '$dir/$filename');
      emit(ArControllerSuccessDownloadSubsequentModel(itemID: itemID, filename: filename, category: model.category!));
    } catch (e) {
      debugPrint('Error downloading file: $e');
      // Handle the error appropriately, e.g., show an error message, retry, etc.
    }
  }
}
