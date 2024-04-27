import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

part 'sold_list_event.dart';
part 'sold_list_state.dart';

class SoldListBloc extends Bloc<SoldListEvent, SoldListState> {
  SoldListBloc() : super(SoldListInitial()) {
    on<SoldListDataFetched>(soldListDataFetched);
    on<SoldListDataFetchedByTitle>(soldListDataFetchedByTitle);
    //delete item
    on<DeleteItem>(deleteItem);
    on<ProductModification>(productModification);
    on<RequestEdit>(requestEdit);
  }
     String? id = AuthRepo.getCurrentUserId();
  FutureOr<void> soldListDataFetched(
      SoldListDataFetched event, Emitter<SoldListState> emit) async{
    emit(SoldListFetctedLoading());
 
    List<MarketplaceProductModel> soldListData = await MarketplaceRepo.getSellingItems(id!);
    print('data: ${soldListData.toString()}');
    if (soldListData.isNotEmpty) {
        emit(SoldListDataFetchedByNameSuccess(soldListData: soldListData));
    } else {
      emit( SoldListFetctedFail());
    }
  }


  FutureOr<void> soldListDataFetchedByTitle(
      SoldListDataFetchedByTitle event, Emitter<SoldListState> emit) async {
    emit(SoldListFetctedLoading());
    List<MarketplaceProductModel> soldListData = await MarketplaceRepo.getSellingItemsByTitle(id!,event.title);
    if (soldListData.isNotEmpty) {
      emit(SoldListDataFetchedByNameSuccess(soldListData: soldListData));
    } else {
      emit(SoldListFetctedFail());
    }
  }


  FutureOr<void> deleteItem(DeleteItem event, Emitter<SoldListState> emit) async {
    try {
      String result = await MarketplaceRepo.deleteSellingItem(event.id);
      if(result == "MarketplaceProduct Deleted"){
        emit(DeleteItemSuccess());
        add(SoldListDataFetched());
      }
      else{
        emit(DeleteItemFail());
         add(SoldListDataFetched());
      }
    } catch (e) {
      emit(DeleteItemFail());
       add(SoldListDataFetched());
    }
  }

  Future<FutureOr<void>> productModification(ProductModification event, Emitter<SoldListState> emit) async {
       try {
      String result = await MarketplaceRepo.editMarketplaceProduct(event.id,event.type,event.value);
      if(result == event.value){
        emit(UpdateItemSuccess(value: result, type: event.type, index: event.index));
   //     add(RequestEdit(isEdit: false, type: event.type));
        //add(SoldListDataFetched());
      }
      else{
        emit(UpdateItemFail());
       //  add(SoldListDataFetched());
      }
    } catch (e) {
      emit(UpdateItemFail());
 //      add(SoldListDataFetched());
    }
  }


  FutureOr<void> requestEdit(RequestEdit event, Emitter<SoldListState> emit) {
    //change isedit to true
    emit(RequestEditSuccess(type: event.type,isEdit: event.isEdit, index: event.index));
  }
}