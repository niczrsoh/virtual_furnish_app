import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/model/ChatAndNotification/chat_model.dart';
import 'package:virtual_furnish_app/data/model/ChatAndNotification/message_%20model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/seller_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';
import 'package:virtual_furnish_app/data/repo/ChatAndNotification/chat_repo.dart';
part 'manage_messages_event.dart';
part 'manage_messages_state.dart';

class ManageMessagesBloc
    extends Bloc<ManageMessagesEvent, ManageMessagesState> {
  ManageMessagesBloc() : super(ManageMessagesInitial()) {
    on<DirectToChatRoomEvent>(directToChatRoomEvent);
    on<FetchChatRoomListEvent>(fetchChatRoomListEvent);
    on<FetchMessagesEvent>(fetchMessagesEvent);
    on<AddMessageEvent>(addMessageEvent);
    on<OpenChatRoomEvent>(openChatRoomEvent);
  }
  FutureOr<void> openChatRoomEvent(OpenChatRoomEvent event, Emitter<ManageMessagesState> emit) async {
    emit(MessagesFetching());
     String userType = await UserRepo.getCurrentUserType();
    ChatModel chatModel = await ChatRepo.openChatRoomFromList(event.chatID, userType);
    if (chatModel != ChatModel()) {
      if (userType == "user") {
        SellerAccountModel opponentUser =
            await SellerRepo.getSellerInfo(chatModel.opponentID!);
        if (opponentUser != Exception()) {
          List<MessageModel> messages =
              await ChatRepo.getAllChatMessages(chatModel, userType);
          if (messages != Exception()) {
            emit(ChatRoomFound(
                chatRoom: chatModel,
                opponentSeller: opponentUser,
                messages: messages));
          }
        } else {
          emit(ChatRoomNotFound());
        }
      } else if (userType == "seller") {
        UserModel opponentUser = await UserRepo.getUser(chatModel.opponentID!);
        if (opponentUser != Exception()) {
          List<MessageModel> messages =
              await ChatRepo.getAllChatMessages(chatModel, userType);
          if (messages != Exception()) {
            emit(ChatRoomFound(
                chatRoom: chatModel,
                opponentUser: opponentUser,
                messages: messages));
          }
        } else {
          emit(ChatRoomNotFound());
        }
      }
    }
  }
  FutureOr<void> directToChatRoomEvent(
      DirectToChatRoomEvent event, Emitter<ManageMessagesState> emit) async {
        emit(MessagesFetching());
    ChatModel chatModel = await ChatRepo.openChatRoom(event.opponentID);
    if (chatModel != ChatModel()) {
      SellerAccountModel opponentUser =
          await SellerRepo.getSellerInfo(chatModel.opponentID!);
      if (opponentUser != Exception()) {
        List<MessageModel> messages =
            await ChatRepo.getAllChatMessages(chatModel, "user");
        if (messages != Exception()) {
          emit(ChatRoomFound(
              chatRoom: chatModel,
              opponentSeller: opponentUser,
              messages: messages));
        }
      } else {
        emit(ChatRoomNotFound());
      }
    }
  }

  FutureOr<void> fetchChatRoomListEvent(
      FetchChatRoomListEvent event, Emitter<ManageMessagesState> emit) async {
    emit(ChatRoomListFetching());
    String userType = await UserRepo.getCurrentUserType();
    List<ChatModel> model = await ChatRepo.getChatRoomList( userType);
    
    if (userType == "user") {
      List<SellerAccountModel> sellerList = [];
      for (int i = 0; i < model.length; i++) {
        SellerAccountModel seller =
            await SellerRepo.getSellerInfo(model[i].opponentID!);
        sellerList.add(seller);
      }
      if (sellerList.isNotEmpty)
        emit(ChatRoomListFetched(chatRoom: model, sellerList: sellerList, currentUserType: userType));
      else
        emit(ChatRoomListEmpty());
    } else if (userType == "seller") {
      List<UserModel> userList = [];
      for (int i = 0; i < model.length; i++) {
        UserModel user = await UserRepo.getUser(model[i].opponentID!);
        userList.add(user);
      }
      if (userList.isNotEmpty)
        emit(ChatRoomListFetched(chatRoom: model, userList: userList, currentUserType: userType));
      else
        emit(ChatRoomListEmpty());
    } else {
      emit(ChatRoomListNotFetched());
    }
  }

  FutureOr<void> fetchMessagesEvent(
      FetchMessagesEvent event, Emitter<ManageMessagesState> emit) {}

  FutureOr<void> addMessageEvent(
      AddMessageEvent event, Emitter<ManageMessagesState> emit) async {
    Timestamp time = Timestamp.now();
    ChatModel chatModel =
        ChatModel(id: event.chatID, opponentID: event.opponentID);
    MessageModel message = MessageModel(
        id: event.messageID,
        textMessage: event.message,
        time: time,
        sentBy: "Me");
    String isSeller = await SellerRepo.isSeller(event.opponentID);
    String flag = await ChatRepo.addChatMessage(chatModel, message, isSeller);
    if (flag == "Message Sent Successfully") {
      emit(MessageSent(id: event.messageID));
    } else {
      emit(MessageNotSent(error: "Message not sent"));
    }
  }


}
