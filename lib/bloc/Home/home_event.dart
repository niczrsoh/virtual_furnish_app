part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeLoaded extends HomeEvent {}

class HomeDataFetched extends HomeEvent {
  //initial data
  String title;
  HomeDataFetched({required this.title});
}

class HomeDataFetchedByTitle extends HomeEvent {
  final String title;
  HomeDataFetchedByTitle({required this.title});
}

class HomeDataAdded extends HomeEvent {
  final HomeModel homeModel;

  HomeDataAdded({required this.homeModel});
}