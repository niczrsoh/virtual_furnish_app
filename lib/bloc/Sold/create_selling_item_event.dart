// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_selling_item_bloc.dart';

sealed class CreateSellingItemEvent extends Equatable {
  const CreateSellingItemEvent();

  @override
  List<Object> get props => [];
}
class AddProduct extends CreateSellingItemEvent {
  final String? name;
  final String? category;
  final int? amount;
  final int? buyers;
  final String? description;
  final String? location;
  final List<dynamic>? images;
  final String? sellerID;
  final String? video;
  final double? price;
  final String? threeDimensionModel;
  AddProduct({
    this.name,
    this.category,
    this.amount,
    this.buyers,
    this.description,
    this.location,
    this.images,
    this.sellerID,
    this.video,
    this.price,
    this.threeDimensionModel,
  });
  @override
  List<Object> get props => [name!, category!, amount!, buyers!, description!, location!, images!, sellerID!, video!, price!, threeDimensionModel!];
}
