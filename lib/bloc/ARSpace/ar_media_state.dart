part of 'ar_media_bloc.dart';

sealed class ArMediaState extends Equatable {
  const ArMediaState();
  
  @override
  List<Object> get props => [];
}

final class ArMediaInitial extends ArMediaState {}
final class ArMediaActionState extends ArMediaState {}
final class ArMediaFromGuest extends ArMediaState {}
final class ArMediaLoaded extends ArMediaState {
  final List<ARMediaStorageModel> arMediaList;
  ArMediaLoaded(this.arMediaList);
}

final class ArMediaError extends ArMediaState {
  final String message;
  ArMediaError(this.message);
}

final class ArMediaLoading extends ArMediaState {}

final class ArMediaEmpty extends ArMediaState {}

final class ArMediaAdded extends ArMediaActionState {
  final String message;
  ArMediaAdded(this.message);
}

final class ArMediaDeleted extends ArMediaActionState {
  final String message;
  ArMediaDeleted(this.message);
}

