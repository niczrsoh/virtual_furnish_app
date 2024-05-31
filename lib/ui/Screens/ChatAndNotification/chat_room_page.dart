import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/bloc/ChatAndNotification/manage_messages_bloc.dart';
import 'package:virtual_furnish_app/data/model/ChatAndNotification/message_%20model.dart';
import 'package:virtual_furnish_app/main.dart';
import 'package:virtual_furnish_app/ui/Styles/export_styles.dart';

class ChatRoomPage extends StatefulWidget {
  ChatRoomPage({super.key, required this.bloc});
  ManageMessagesBloc bloc;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  static List<MessageModel> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BlocBuilder<ManageMessagesBloc, ManageMessagesState>(
        buildWhen: (previous, current) => current is ChatRoomFound,
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatRoomFound:
              final chatRoom = state as ChatRoomFound;
              return Text((chatRoom.opponentSeller != null)
                  ? chatRoom.opponentSeller?.shopName ?? ""
                  : chatRoom.opponentUser?.username ?? "");
            default:
              return Text("Chat Room");
          }
        },
      )),
      body: BlocConsumer<ManageMessagesBloc, ManageMessagesState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is MessageSent) {
            int length = (messages.length > 20) ? 20 : messages.length;
            for (int i = length - 1; i >= 0; i--) {
              if (messages[i].id == state.id) {
                setState(() {
                  messages[i].checked = true;
                });
                break;
              }
            }
          } else if (state is MessageNotSent) {
            //show message not sent
            messages.last.checked = false;
          }
        },
        buildWhen: (previous, current) =>
            current is! MessageSent &&
            current is! MessageNotSent &&
            current is! ManageChatRoomState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case ManageMessagesInitial:
              return Center(child: CircularProgressIndicator());
            case MessagesFetching:
              return Center(child: CircularProgressIndicator());
            case ChatRoomFound:
              final currentState = state as ChatRoomFound;
              messages = currentState.messages;
              return Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment:
                                (state.messages[index].sentBy == "Me")
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: PaddingStyles.paddingStyle1,
                                margin: PaddingStyles.paddingStyle1,
                                width: mq.width * 0.4,
                                decoration: BoxDecoration(
                                  //rounded
                                  borderRadius: BorderRadius.circular(10),
                                  color: (state.messages[index].sentBy == "Me")
                                      ? CustomColor.vfPrimaryColor
                                          .withOpacity(0.2)
                                      : CustomColor.secondaryBackgroundColor,
                                ),
                                child: BlocBuilder<ManageMessagesBloc,
                                        ManageMessagesState>(
                                    buildWhen: (previous, current) =>
                                        state is MessageSent ||
                                        state is MessageNotSent,
                                    builder: (context, state) {
                                      return Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                                  messages[index].textMessage ??
                                                      "")),
                                          Expanded(child: SizedBox()),
                                          //two small icons for read and unread
                                          messages[index].checked == null
                                              ? Icon(Icons.av_timer)
                                              : (messages[index].checked!)
                                                  ? Icon(Icons.check, size: 10)
                                                  : Icon(Icons.check_circle,
                                                      size: 10),
                                        ],
                                      );
                                    }),
                              ),
                            ]);
                      },
                    ),
                  ),
                  //send message
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              decoration: const InputDecoration(
                                hintText: "Type your message",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              //randomly generate message id
                              String messageID = messages.length.toString() +
                                  Random().nextInt(100).toString();
                              setState(() {
                                messages.add(MessageModel(
                                  id: messageID,
                                  textMessage: messageController.text,
                                  sentBy: "Me",
                                  time: Timestamp.fromDate(DateTime.now()),
                                ));
                              });
                              //send message
                              widget.bloc.add(
                                AddMessageEvent(
                                  messageID: messageID,
                                  opponentID: (currentState.opponentSeller ==
                                          null)
                                      ? currentState.opponentUser?.id ?? ""
                                      : currentState.opponentSeller?.id ?? "",
                                  chatID: state.chatRoom.id ?? "",
                                  message: messageController.text,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            // case ChatRoomListFetched:
            //   return Center(child: Text("Chat Room List Fetched"));
            // case MessagesFetched:
            //   return Center(child: Text("Messages Fetched"));
            // case MessageAdded:
            //   return Center(child: Text("Message Added"));
            default:
              return Center(child: Text("Error"));
          }
        },
      ),
    );
  }
}
