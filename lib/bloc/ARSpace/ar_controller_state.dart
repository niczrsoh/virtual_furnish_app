part of 'ar_controller_bloc.dart';

sealed class ArControllerState extends Equatable {
  const ArControllerState();
  
  @override
  List<Object> get props => [];
}

final class ArControllerInitial extends ArControllerState {}
final class ArControllerLoading extends ArControllerState {}

final class ArControllerActionState extends ArControllerState {
  ArControllerActionState();
}
final class ArControllerActionLoading extends ArControllerActionState {}
final class ArControllerSuccessFetchedProducts extends ArControllerActionState {
  final List<MarketplaceProductModel> suggestedProduct;
  ArControllerSuccessFetchedProducts(this.suggestedProduct);
  
  @override
  List<Object> get props => [suggestedProduct];
}


final class ArControllerFailureFetchedProducts extends ArControllerActionState {
  final String error;
  ArControllerFailureFetchedProducts(this.error);
  
  @override
  List<Object> get props => [error];
}

final class ArControllerSuccessDownloadModel extends ArControllerState {
  String filename;
  String itemID;
  String category;
  ArControllerSuccessDownloadModel({required this.itemID,required this.filename, required this.category});
}

final class ArControllerSuccessDownloadSubsequentModel extends ArControllerState {
  String filename;
  String itemID;
  String category;
  ArControllerSuccessDownloadSubsequentModel({required this.itemID,required this.filename, required this.category});
}

final class ArControllerFailedDownloadModel extends ArControllerState {
  ArControllerFailedDownloadModel();
}