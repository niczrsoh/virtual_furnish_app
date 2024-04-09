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

class DeleteItem extends SoldListEvent {
  final String id;
  DeleteItem({required this.id});
  @override
  List<Object> get props => [id];
}