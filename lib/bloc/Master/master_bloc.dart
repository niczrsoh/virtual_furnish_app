import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  MasterBloc() : super(MasterInitial(tabIndex: 0)) {
    on<FetchUserData>(fetchUserData);
    on<MasterEvent>(masterEvent);
  }
  
  FutureOr<void> fetchUserData(FetchUserData event, Emitter<MasterState> emit) async{
      String userType = await SellerRepo.isSeller(AuthRepo.getCurrentUserId()!);
      if(userType!=null){
        emit(MasterUserDataFetched(tabIndex: 0, userType: userType));}
      else{
        emit(MasterUserDataFetched(tabIndex: 0, userType: "none"));
      }
    }

  FutureOr<void> masterEvent(MasterEvent event, Emitter<MasterState> emit) {
        if(event is TabChange){
         print(event.tabIndex);
        emit(MasterTabChanged(tabIndex: event.tabIndex, userType: state.userType));
      }
  }
}
