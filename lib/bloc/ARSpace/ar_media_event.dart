part of 'ar_media_bloc.dart';

sealed class ArMediaEvent extends Equatable {
  const ArMediaEvent();

  @override
  List<Object> get props => [];
}


class ArMediaLoad extends ArMediaEvent {
  ArMediaLoad();
}


class ArMediaAdd extends ArMediaEvent {
  final String? image;
  final String? video;
  ArMediaAdd({this.image, this.video});
}