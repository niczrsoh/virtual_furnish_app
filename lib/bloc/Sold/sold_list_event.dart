part of 'sold_list_bloc.dart';

sealed class SoldListEvent extends Equatable {
  const SoldListEvent();

  @override
  List<Object> get props => [];
}

class SoldListDataFetched extends SoldListEvent {
  SoldListDataFetched();
  @override
  List<Object> get props => [];
}

class SoldListDataFetchedByTitle extends SoldListEvent {
  final String title;
  SoldListDataFetchedByTitle({required this.title});
  @override
  List<Object> get props => [title];
}

class ProductModification extends SoldListEvent {
  final String id;
  final String type;
  final String value;
  final int index;
  ProductModification(
      {required this.id,
      required this.type,
      required this.index,
      required this.value});
  @override
  List<Object> get props => [id, type, value];
}

class DeleteItem extends SoldListEvent {
  final String id;
  DeleteItem({required this.id});
  @override
  List<Object> get props => [id];
}

class RequestEdit extends SoldListEvent {
  final bool isEdit;
  final String type;
  final int index;
  RequestEdit({required this.isEdit, required this.type, required this.index});
}