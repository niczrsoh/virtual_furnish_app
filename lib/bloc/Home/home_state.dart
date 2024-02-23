part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionState extends HomeState{}
class HomeInitial extends HomeState {}

class HomeFetctedLoading extends HomeState {}
class HomeFetchedSuccess extends HomeState {
  final List<HomeModel> homeData;
  HomeFetchedSuccess({
    required this.homeData,
  });
}
class HomeFetctedFail extends HomeState {}
class HomeDataFetchedByNameSuccess extends HomeState {
  final List<HomeModel> homeData;
  HomeDataFetchedByNameSuccess({
    required this.homeData,
  });
}
class HomeDataAddedSuccess extends HomeActionState {}
class HomeDataAddedFail extends HomeActionState {}