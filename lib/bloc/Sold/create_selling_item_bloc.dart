import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/bloc/Sold/sold_list_bloc.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

part 'create_selling_item_event.dart';
part 'create_selling_item_state.dart';

class CreateSellingItemBloc extends Bloc<CreateSellingItemEvent, CreateSellingItemState> {
  CreateSellingItemBloc() : super(CreateSellingItemInitial()) {
    on<AddProduct>(addProduct);
  }

  Future<FutureOr<void>> addProduct(AddProduct event, Emitter<CreateSellingItemState> emit) async {
    emit(CreateSellingItemLoading());
    MarketplaceProductModel productModel = MarketplaceProductModel(
      name: event.name,
      category: event.category,
      amount: event.amount,
      buyers: event.buyers,
      description: event.description,
      location: event.location,
      images: event.images,
      sellerID: event.sellerID,
      video: event.video,
      price: event.price,
      threeDimensionModel: event.threeDimensionModel,
    );
    //add into repo
    String message = await MarketplaceRepo.addProduct(productModel);
    if (message == 'Product Added') {
      emit(CreateSellingItemSuccess(message: 'Product added successfully'));
    } else {
      emit(CreateSellingItemFailed(message: 'Failed to add product'));
    }
  }
  
}
