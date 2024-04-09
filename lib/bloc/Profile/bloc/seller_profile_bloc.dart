import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';

part 'seller_profile_event.dart';
part 'seller_profile_state.dart';

class SellerProfileBloc extends Bloc<SellerProfileEvent, SellerProfileState> {
  SellerProfileBloc() : super(SellerProfileInitial()) {
    on<SellerProfileSearch>(sellerProfileSearch);

  }


  FutureOr<void> sellerProfileSearch(SellerProfileSearch event, Emitter<SellerProfileState> emit)async {
    String? id = AuthRepo.getCurrentUserId();
    SellerAccountModel seller = await SellerRepo.getSellerInfo(id ?? "");
    if(seller != null){
      UserModel user = await UserRepo.getUser(seller.userID ?? "");
      emit(SellerProfileFoundState(sellerProfile: seller, userProfile: user));
  }else{
      emit(SellerProfileError(errorMessage: "Error"));
    }
  }
}
