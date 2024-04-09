import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  ItemListBloc() : super(ItemListInitial()) {
    on<ItemListFetchedByCategory>(itemDataFetchedByCategory);
    on<ItemListFetchedByTitle>(itemDataFetchedByTitle);
  }
    
  FutureOr<void> itemDataFetchedByCategory(
      ItemListFetchedByCategory event, Emitter<ItemListState> emit) async{
    emit(ItemListFetctedLoading());
    List<MarketplaceProductModel> itemData = await MarketplaceRepo.fetchMarketplaceProductByCategory(event.category);
    if (itemData.isNotEmpty) {
        emit(ItemListFetchedByNameSuccess(itemData: itemData));
      }else{
      emit( ItemListFetctedFail());
    }
  }

  FutureOr<void> itemDataFetchedByTitle(
      ItemListFetchedByTitle event, Emitter<ItemListState> emit) async {
    emit(ItemListFetctedLoading());
    List<MarketplaceProductModel> itemData = await MarketplaceRepo.fetchMarketplaceProductByTitle(event.title);
    if (itemData.isNotEmpty) {
      emit(ItemListFetchedByNameSuccess(itemData: itemData));
    } else {
      emit(ItemListFetctedFail());
    }
  }
  }
