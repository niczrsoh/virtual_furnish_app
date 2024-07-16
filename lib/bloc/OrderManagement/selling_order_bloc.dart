import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/market_order_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';
import 'package:virtual_furnish_app/data/repo/OrderManagement/order_repo.dart';

part 'selling_order_event.dart';
part 'selling_order_state.dart';

class SellingOrderBloc extends Bloc<SellingOrderEvent, SellingOrderState> {
  SellingOrderBloc() : super(SellingOrderInitial()) {
    on<FetchItems>(fetchItems);
    on<OrderModification>(orderModification);
    on<RequestOrderEdit>(requestEdit);
  }

  Future<FutureOr<void>> fetchItems(FetchItems event, Emitter<SellingOrderState> emit) async {
    emit(SellingOrderLoading());
    try {
      List<MarketOrder> items = await OrderRepo.getOrders();
      //get items details from the list
      List<MarketplaceProductModel> product_model = [];
      for (int i = 0; i < items.length; i++) {
        MarketplaceProductModel product = await MarketplaceRepo.getSellingItem(items[i].productID.toString());
        product_model.add(product);}
      if(items.isEmpty || product_model.isEmpty){
        emit(SellingOrderEmpty());
      }else if (items.isNotEmpty && product_model.isNotEmpty){
        emit(SellingOrderLoaded(items: items, product_model: product_model));
      }else{
        emit(SellingOrderError(message: 'No data found'));
      }
    } catch (e) {
      emit(SellingOrderError(message: e.toString() ));
    }
  }
    Future<FutureOr<void>> orderModification(OrderModification event, Emitter<SellingOrderState> emit) async {
       try {
      String type = (event.type.contains('Transaction No')) ? "transactionNumber" : event.type;
      String result = await OrderRepo.updateOrder(event.id,type,event.value, event.customerID);
     
      if(result == event.value){
        emit(UpdateOrderItemSuccess(value: result, type: event.type, index: event.index));
      }
      else{
        emit(UpdateOrderItemFail());
      }
    } catch (e) {
      emit(UpdateOrderItemFail());
    }
  }


  FutureOr<void> requestEdit(RequestOrderEdit event, Emitter<SellingOrderState> emit) {
    //change isedit to true
    emit(OrderRequestEditSuccess(type: event.type,isEdit: event.isEdit, index: event.index));
  }
}
