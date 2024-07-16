import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/ChatAndNotification/manage_messages_bloc.dart';

class ChatListPage extends StatelessWidget {
   ChatListPage({super.key,required this.bloc});
  ManageMessagesBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      body: BlocConsumer<ManageMessagesBloc, ManageMessagesState>(
        bloc: bloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        buildWhen: (previous, current) => current is ManageChatRoomState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatRoomListFromGuest:
              return Center(
                child: Text("Please login to use chat feature!"),
              );
            case ManageMessagesInitial:
              bloc.add(FetchChatRoomListEvent());
              return Center(
                child: CircularProgressIndicator(),
              );
            case ChatRoomListFetching:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ChatRoomListEmpty:
              return Center(
                child: Text("No chat rooms found!"),
              );
            case ChatRoomListFetched:
              final chatRoomList = state as ChatRoomListFetched;
              return ListView.builder(
                itemCount: chatRoomList.chatRoom.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: chatRoomList.currentUserType == "user"
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                chatRoomList.sellerList![index].profilePic ?? ""),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                chatRoomList.userList![index].profilePic ?? ""),
                          ),
                    title: (chatRoomList.currentUserType == "user")
                        ? Text(chatRoomList.sellerList![index].shopName ?? "")
                        : Text(chatRoomList.userList![index].username ?? ""),
                    subtitle: Text(chatRoomList.chatRoom[index].priority ?? ""),
                    onTap: () {
                      Navigator.pushNamed(context, "/chat_room", arguments: {"from":"chatList","chatID": chatRoomList.chatRoom[index].id});
                    },
                  );
                },
              );
            default:
              bloc.add(FetchChatRoomListEvent());
              return Center(
                child: Text("Something went wrong!"),
              );
          }
        },
      ),
    );
  }
}
