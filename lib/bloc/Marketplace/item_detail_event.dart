part of 'item_detail_bloc.dart';

@immutable
sealed class ItemDetailEvent {}

class ItemLoaded extends ItemDetailEvent {}
class ItemDetailFetched extends ItemDetailEvent {
  final String id;
  ItemDetailFetched({required this.id});
}