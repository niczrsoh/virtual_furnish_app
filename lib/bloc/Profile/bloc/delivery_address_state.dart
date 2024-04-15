part of 'delivery_address_bloc.dart';

sealed class DeliveryAddressState extends Equatable {
  const DeliveryAddressState();
  
  @override
  List<Object> get props => [];
}

final class DeliveryAddressInitial extends DeliveryAddressState {}
