import 'dart:async';

import 'package:bloc/bloc.dart';
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
      }
      else{
        emit(DeleteItemFail());
      }
    } catch (e) {
      emit(DeleteItemFail());
    }
  }
}