part of 'create_selling_item_bloc.dart';

sealed class CreateSellingItemState extends Equatable {
  const CreateSellingItemState();
  
  @override
  List<Object> get props => [];
}

final class CreateSellingItemInitial extends CreateSellingItemState {}

final class CreateSellingItemLoading extends CreateSellingItemState {}

final class CreateSellingItemSuccess extends CreateSellingItemState {
  final String message;
  CreateSellingItemSuccess({required this.message});
  @override
  List<Object> get props => [message];
}

final class CreateSellingItemFailed extends CreateSellingItemState {
  final String message;
  CreateSellingItemFailed({required this.message});
  @override
  List<Object> get props => [message];
}