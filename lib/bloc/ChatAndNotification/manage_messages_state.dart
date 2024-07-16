part of 'manage_messages_bloc.dart';

sealed class ManageMessagesState extends Equatable {
  const ManageMessagesState();
  
  @override
  List<Object> get props => [];
}
final class ChatRoomListFromGuest extends ManageMessagesState {}
final class ManageMessagesInitial extends ManageMessagesState {}
final class ManageChatRoomState extends ManageMessagesState {}
final class ChatRoomFound extends ManageMessagesState {
  ChatRoomFound({required this.chatRoom, this.opponentSeller, this.opponentUser, required this.messages});
  final ChatModel chatRoom;
  final SellerAccountModel? opponentSeller;
  final UserModel? opponentUser;
  final List<MessageModel> messages;
  @override
  List<Object> get props => [chatRoom];
}
final class MessagesFetching extends ManageMessagesState {}
final class ChatRoomNotFound extends ManageMessagesState {
  ChatRoomNotFound();
}
final class ChatRoomListFetched extends ManageChatRoomState {
  final List<ChatModel> chatRoom;
  final List<SellerAccountModel>? sellerList;
  final List<UserModel>? userList;
  final String currentUserType;
  ChatRoomListFetched({required this.chatRoom,  this.sellerList, this.userList, required this.currentUserType});

}
//chatroom is empty
final class ChatRoomListEmpty extends ManageChatRoomState {}
//loading chatroom
final class ChatRoomListFetching extends ManageChatRoomState {}
final class ChatRoomListNotFetched extends ManageMessagesState {}
final class MessagesFetched extends ManageMessagesState {}

final class MessageAdded extends ManageMessagesState {}

final class MessageSent extends ManageMessagesState {
  String id;
  MessageSent({required this.id});
}

final class MessageNotSent extends ManageMessagesState {
  String error;
  MessageNotSent({required this.error});
}
