import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';
import 'package:virtual_furnish_app/data/repo/Marketplace/marketplace_repo.dart';

part 'item_detail_event.dart';
part 'item_detail_state.dart';

class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {
  ItemDetailBloc() : super(ItemDetailInitial()) {
    on<ItemDetailFetched>(itemDetailFetched);
  }

  Future<FutureOr<void>> itemDetailFetched(
      ItemDetailFetched event, Emitter<ItemDetailState> emit) async {
    emit(ItemDetailFetctedLoading());
    try {
      MarketplaceProductModel itemData =
          await MarketplaceRepo.getMarketplaceProductById(event.id);
      if (itemData == null) {
        emit(ItemDetailFetctedFail());
      } else {
        if (itemData.sellerID != null) {
          SellerAccountModel sellerData =
              await SellerRepo.getSellerInfo(itemData.sellerID!);
          UserModel? user = await UserRepo.getUser(sellerData.userID!);
          if (sellerData != null && user != null) {
               emit(ItemDetailFetchedSuccess(
                itemData: itemData, sellerData: sellerData, userData: user));
          }
        } else {
          emit(ItemDetailFetctedFail());
        }
      }
    } catch (e) {
      emit(ItemDetailFetctedFail());
    }
  }
}
