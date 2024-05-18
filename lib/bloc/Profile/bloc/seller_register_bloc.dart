import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_furnish_app/core/helpers/auth_provider.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';

part 'seller_register_event.dart';
part 'seller_register_state.dart';
  
class SellerRegisterBloc extends Bloc<SellerRegisterEvent, SellerRegisterState> {
  SellerRegisterBloc() : super(SellerRegisterInitial()) {
    on<SellerRegisterFetchList>(sellerRegisterFetchList);
    on<SellerRegisterCreate>(sellerRegisterCreate);
    on<SellerRegisterUploadDocument>(sellerRegisterUploadDocument);
    on<SellerRegisterBusinessType>(sellerRegisterBusinessType);
  }

  Future<FutureOr<void>> sellerRegisterCreate(SellerRegisterCreate event, Emitter<SellerRegisterState> emit) async {
    final userID = await AuthRepo.getCurrentUserId();
    
     final message = await AuthRepo.registerSellerWithEmailandPassword(event.email, event.password);
      if (message.contains("uid:")) {
        SellerAccountModel sellerAccountModel = SellerAccountModel(
          id: message.split(":")[1],
          email: event.email,
          shopName: event.shopName,
          location: event.location,
          type: event.businessType,
          bankDoc: event.companyBankDoc ?? event.individualBankDoc,
          ssmFile: event.companySsmDoc ?? "",
          nricFile: event.individualIcDoc ?? "",
          userID: userID
        );
        final value = await SellerRepo.addSellRegister(sellerAccountModel);
        if (value == "Seller Registered") {
          emit(SellerRegisterSuccess(message: value));
        } else {
          emit(SellerRegisterFail(message: value));
        }
  }
}

  Future<FutureOr<void>> sellerRegisterUploadDocument(SellerRegisterUploadDocument event, Emitter<SellerRegisterState> emit) async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result != null) {
        final file = result.files.single;
        emit(SellerRegisterDocumentUpdated(docType: event.docType, docPath: file));
      }
  }

  FutureOr<void> sellerRegisterBusinessType(SellerRegisterBusinessType event, Emitter<SellerRegisterState> emit) {
    emit(SellerRegisterBusinessTypeUpdated(businessType: event.businessType));
  }

  FutureOr<void> sellerRegisterFetchList(SellerRegisterFetchList event, Emitter<SellerRegisterState> emit) async {
    //fetch seller list
   await SellerRepo.getRegisteredShop().then((value) {
    if(value.shopName == null){
      emit(SellerRegisterListFetchedEmpty());
    }else{
      emit(SellerRegisterListFetchedSuccess(sellerList: value));}
    }).catchError((e) {
      emit(SellerRegisterListFetchedFail(message: e.toString()));
    });
  }
}