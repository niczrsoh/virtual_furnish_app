import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:virtual_furnish_app/data/model/Home/home_model.dart';
import 'package:virtual_furnish_app/data/repo/Home/home_repo.dart';
part 'home_event.dart';
part 'home_state.dart';

//business logic
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeDataFetched>(homeDataFetched);
    on<HomeDataAdded>(homeDataAdded);
    on<HomeDataFetchedByTitle>(homeDataFetchedByTitle);
  }

  FutureOr<void> homeDataFetched(
      HomeDataFetched event, Emitter<HomeState> emit) async{
    emit(HomeFetctedLoading());
    List<HomeModel> homeData = await HomeRepo.getHomeData();
    if (homeData.isNotEmpty) {
      if(event.title!=""){
        List<HomeModel> homeData = await HomeRepo.fetchHomeDataByTitle(event.title);
        emit(HomeDataFetchedByNameSuccess(homeData: homeData));
      }else{
            List<HomeModel> homeData = await HomeRepo.getHomeData();
      emit(HomeFetchedSuccess(homeData: homeData));}
    } else {
      emit( HomeFetctedFail());
    }
  }

  FutureOr<void> homeDataAdded(
      HomeDataAdded event, Emitter<HomeState> emit) async {
    bool response = await HomeRepo.addHomeData(event.homeModel);
    if (response) {
      emit(HomeDataAddedSuccess());
    } else {
      emit(HomeDataAddedFail());
    }
  }

  FutureOr<void> homeDataFetchedByTitle(
      HomeDataFetchedByTitle event, Emitter<HomeState> emit) async {
    emit(HomeFetctedLoading());
    List<HomeModel> homeData = await HomeRepo.fetchHomeDataByTitle(event.title);
    if (homeData.isNotEmpty) {
      emit(HomeDataFetchedByNameSuccess(homeData: homeData));
    } else {
      emit(HomeFetctedFail());
    }
  }
}
