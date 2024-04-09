part of 'item_list_bloc.dart';

@immutable
sealed class ItemListEvent {}

class ItemLoaded extends ItemListEvent {}

class ItemListFetchedByCategory extends ItemListEvent {
  //initial data
  final String category;
  ItemListFetchedByCategory({required this.category});
}

class ItemListFetchedByTitle extends ItemListEvent {
  final String title;
  ItemListFetchedByTitle({required this.title});
}