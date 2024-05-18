import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/order_status_model.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';
import 'package:virtual_furnish_app/data/repo/OrderManagement/order_repo.dart';

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  OrderDetailBloc() : super(OrderDetailInitial()) {
    on<FetchOrderByType>(fetchEventByType);
  }

  Future<FutureOr<void>> fetchEventByType(FetchOrderByType event, Emitter<OrderDetailState> emit) async {
    emit(OrderDetailLoading());
    try {
      List<OrderStatus> orders = await OrderRepo.fetchOrderByType(event.type);
      List<MarketplaceProductModel> product_model = [];
      for (int i = 0; i < orders.length; i++) {
        MarketplaceProductModel product = await MarketplaceRepo.getSellingItem(orders[i].productID.toString());
        product_model.add(product);}
      if (orders.isEmpty) {
        emit(OrderDetailEmpty());
      } else if (orders.isNotEmpty) {
        emit(OrderDetailLoaded(orders, event.type, product_model));
      } else {
        emit(OrderDetailError('No data found'));
      }
    } catch (e) {
      emit(OrderDetailError(e.toString()));
  }
}
}
