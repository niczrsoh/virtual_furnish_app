import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/ARSpace/ar_media_storage_model.dart';
import 'package:virtual_furnish_app/data/repo/ARSpace/ar_sapce_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
part 'ar_media_event.dart';
part 'ar_media_state.dart';

class ArMediaBloc extends Bloc<ArMediaEvent, ArMediaState> {
  ArMediaBloc() : super(ArMediaInitial()) {
    on<ArMediaLoad>(arMediaLoad);
    on<ArMediaAdd>(arMediaAdd);
  }

  FutureOr<void> arMediaLoad(ArMediaLoad event, Emitter<ArMediaState> emit) async {
    emit(ArMediaLoading());
    if(AuthRepo.isGuest()==true){
      emit(ArMediaFromGuest());
      return;
    }
    List<ARMediaStorageModel> models= await ArSpaceRepo.getAllMedia();
    try{
    if(models.isNotEmpty){
      emit(ArMediaLoaded(models));
    }else{
      emit(ArMediaEmpty());}
    }catch(e){
      emit(ArMediaError(e.toString()));
  }}

  FutureOr<void> arMediaAdd(ArMediaAdd event, Emitter<ArMediaState> emit) async {
    //get current time
    DateTime now = DateTime.now();
    //change to timestamp
    Timestamp myTimeStamp = Timestamp.fromDate(now);
    ARMediaStorageModel model = ARMediaStorageModel(image: event.image, video: event.video, time: myTimeStamp, category: "My Room");
    String message = await ArSpaceRepo.addMedia(model);
    if(message == "Media Added"){
    emit(ArMediaAdded(message));}
    else{
      emit(ArMediaError(message));
    }
  }
}
