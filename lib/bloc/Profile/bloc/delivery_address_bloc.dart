import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delivery_address_event.dart';
part 'delivery_address_state.dart';

class DeliveryAddressBloc extends Bloc<DeliveryAddressEvent, DeliveryAddressState> {
  DeliveryAddressBloc() : super(DeliveryAddressInitial()) {
    on<DeliveryAddressEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
