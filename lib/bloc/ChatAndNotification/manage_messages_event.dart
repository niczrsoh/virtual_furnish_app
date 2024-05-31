part of 'manage_messages_bloc.dart';

sealed class ManageMessagesEvent extends Equatable {
  const ManageMessagesEvent();

  @override
  List<Object> get props => [];
}

//event to direct to the chat room
class DirectToChatRoomEvent extends ManageMessagesEvent {
  final String opponentID;
  DirectToChatRoomEvent({required this.opponentID});
}
//open a chat room
class OpenChatRoomEvent extends ManageMessagesEvent {
  final String chatID;
  OpenChatRoomEvent({required this.chatID});
}
//fetch list of chat room 
class FetchChatRoomListEvent extends ManageMessagesEvent {
  FetchChatRoomListEvent();
}
//event to fetch list of messages
class FetchMessagesEvent extends ManageMessagesEvent {
  final String chatID;

  FetchMessagesEvent(this.chatID);
}

//event to add new message
class AddMessageEvent extends ManageMessagesEvent {
  final String messageID;
  final String chatID;
  final String message;
  final String opponentID;
  AddMessageEvent({required this.messageID, required this.chatID, required this.message, required this.opponentID});
}