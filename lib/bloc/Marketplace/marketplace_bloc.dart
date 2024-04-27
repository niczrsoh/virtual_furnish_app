import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';
part 'marketplace_event.dart';
part 'marketplace_state.dart';

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc() : super(MarketplaceInitial()) {
    on<SearchEvent>(searchEvent);
    on<FetchMostSellingItems>(fetchMostSellingItems);
  }

  FutureOr<void> searchEvent(SearchEvent event, Emitter<MarketplaceState> emit) async {
     emit(ItemsSearched(searchQuery: event.searchQuery));
  }

  FutureOr<void> fetchMostSellingItems(FetchMostSellingItems event, Emitter<MarketplaceState> emit) async {
    //fetch most selling items
    List<MarketplaceProductModel> items = await  MarketplaceRepo.getMostSellingItems();
    
      if(items.isNotEmpty){
        emit(MostSellingItemsFetched(items: items));
      }else{
         emit(MarketplaceItemsEmpty());
      }
    
  }}

