part of 'ar_controller_bloc.dart';

sealed class ArControllerEvent extends Equatable {
  const ArControllerEvent();

  @override
  List<Object> get props => [];
}


class ArControllerLoad extends ArControllerEvent {
  String itemId;
   ArControllerLoad({required this.itemId});
}

class ArControllerAnalyseObject extends ArControllerEvent {
   String category;
   ArControllerAnalyseObject({required this.category});
}

class ArControllerLoadSubsequentModels extends ArControllerEvent {
  String itemId;
  ArControllerLoadSubsequentModels({required this.itemId});
}
