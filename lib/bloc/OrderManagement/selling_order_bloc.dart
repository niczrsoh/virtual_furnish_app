import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/OrderManagement/market_order_model.dart';

part 'selling_order_event.dart';
part 'selling_order_state.dart';

class SellingOrderBloc extends Bloc<SellingOrderEvent, SellingOrderState> {
  SellingOrderBloc() : super(SellingOrderInitial()) {
    on<SellingOrderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
