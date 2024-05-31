import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_furnish_app/data/model/ARSpace/ar_media_storage_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/sell_account_model.dart';
import 'package:virtual_furnish_app/data/model/Authentication/user_model.dart';
import 'package:virtual_furnish_app/data/model/ChatAndNotification/chat_model.dart';
import 'package:virtual_furnish_app/data/model/ChatAndNotification/message_%20model.dart';
import 'package:virtual_furnish_app/data/model/MarketplaceProduct/product_model.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/auth_repo.dart';
import 'package:virtual_furnish_app/data/repo/Authentication/user_repo.dart';
import 'package:virtual_furnish_app/data/repo/firebaseStorageRepo.dart';

class ChatRepo {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("User");
  static final CollectionReference _sellerCollection =
      FirebaseFirestore.instance.collection("SellAccount");
  static final chatFolderName = "Chat";
  static final messageFolderName = "Message";

  static DocumentReference getUserDocument() {
    String uid = AuthRepo.getCurrentUserId()!;
    return _userCollection.doc(uid);
  }

  static DocumentReference getSellerDocument() {
    String uid = AuthRepo.getCurrentUserId()!;
    return _sellerCollection.doc(uid);
  }

  //delete message
  static Future<String> deleteMessage(
      ChatModel chatRoom, MessageModel message, String opponentType) async {
    try {
      //delete message from firestore for the user and also for the seller
      DocumentReference reference;
      DocumentReference reference2;
      if (opponentType == "seller") {
        reference = getUserDocument()
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference.delete();
        reference2 = _sellerCollection
            .doc(chatRoom.opponentID)
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference2.delete();
      } else {
        reference = getSellerDocument()
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference.delete();
        reference2 = _userCollection
            .doc(chatRoom.opponentID)
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference2.delete();
      }

      //check if deleted
      String checkRef1 = await reference.get().then((value) {
        return MessageModel.fromJson(value.data() as Map<String, dynamic>)
            .textMessage;
      }) as String;
      String checkRef2 = await reference2.get().then((value) {
        return MessageModel.fromJson(value.data() as Map<String, dynamic>)
            .textMessage;
      }) as String;
      if (checkRef1.isEmpty && checkRef2.isEmpty) {
        return "Message Deleted Successfully";
      } else {
        return "Failed to delete message";
      }
    } catch (e) {
      return e.toString();
    }
  }

  //add new message to the chat room
  static Future<String> addChatMessage(
      ChatModel chatRoom, MessageModel message, String opponentType) async {
    try {
      //save chat to firestore for the user and also for the seller
      DocumentReference reference;
      DocumentReference reference2;
      if (opponentType == "seller") {
        reference = getUserDocument()
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference.set(message.toJson());
        reference2 = _sellerCollection
            .doc(chatRoom.opponentID)
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference2.set({
          "textMessage": message.textMessage,
          "sentBy": "Opponent",
          "time": message.time,
        });
      } else {
        reference = getSellerDocument()
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference.set(message.toJson());
        reference2 = _userCollection
            .doc(chatRoom.opponentID)
            .collection(chatFolderName)
            .doc(chatRoom.id)
            .collection(messageFolderName)
            .doc(message.id);
        await reference2.set({
          "textMessage": message.textMessage,
          "sentBy": "Opponent",
          "time": message.time,
        });
      }

      //check if set
      String checkRef1 = await reference.get().then((value) {
        return MessageModel.fromJson(value.data() as Map<String, dynamic>)
            .textMessage;
      }) as String;
      String checkRef2 = await reference2.get().then((value) {
        return MessageModel.fromJson(value.data() as Map<String, dynamic>)
            .textMessage;
      }) as String;
      if (checkRef1 != null && checkRef2.isNotEmpty) {
        await reference.update({"checked": true});
        await reference2.update({"checked": true});
        return "Message Sent Successfully";
      } else {
        return "Failed to send message";
      }
    } catch (e) {
      return e.toString();
    }
  }

  //get all messages
  static Future<List<MessageModel>> getAllChatMessages(
      ChatModel chatModel, String userType) async {
    try {
      List<MessageModel> messageList = [];

      QuerySnapshot querySnapshot = (userType == "user")
          ? await getUserDocument()
              .collection(chatFolderName)
              .doc(chatModel.id)
              .collection(messageFolderName)
              .get()
          : await getSellerDocument()
              .collection(chatFolderName)
              .doc(chatModel.id)
              .collection(messageFolderName)
              .get();
      querySnapshot.docs.forEach((element) {
        MessageModel model =
            MessageModel.fromJson(element.data() as Map<String, dynamic>);
        model.id = element.id;
        messageList.add(model);
      });
      return messageList;
    } catch (e) {
      throw e;
    }
  }

  //get chat room list
  static Future<List<ChatModel>> getChatRoomList(String userType) async {
    try {
      List<ChatModel> chatRoomList = [];

      QuerySnapshot querySnapshot = (userType == "user")
          ? await getUserDocument().collection(chatFolderName).get()
          : await getSellerDocument().collection(chatFolderName).get();
      querySnapshot.docs.forEach((element) {
        ChatModel model =
            ChatModel.fromJson(element.data() as Map<String, dynamic>);
        model.id = element.id;
        chatRoomList.add(model);
      });
      return chatRoomList;
    } catch (e) {
      throw e;
    }
  }

  //seller open a chat room
  static Future<ChatModel> openChatRoomFromList(
      String chatID, String userType) async {
    try {
      ChatModel model;
      if (userType == "seller") {
        model = await getSellerDocument()
            .collection(chatFolderName)
            .doc(chatID)
            .get()
            .then((value) {
          ChatModel model =
              ChatModel.fromJson(value.data() as Map<String, dynamic>);
          model.id = value.id;
          return model;
        }) as ChatModel;
      } else {
        model = await getUserDocument()
            .collection(chatFolderName)
            .doc(chatID)
            .get()
            .then((value) {
          ChatModel model =
              ChatModel.fromJson(value.data() as Map<String, dynamic>);
          model.id = value.id;
          return model;
        }) as ChatModel;
      }
      return model;
    } catch (e) {
      return ChatModel();
    }
  }

  //open a chat room
  static Future<ChatModel> openChatRoom(String opponentID) async {
    try {
      //find if the chat room exist
      QuerySnapshot querySnapshot;
      querySnapshot = await getUserDocument()
          .collection(chatFolderName)
          .where("opponentID", isEqualTo: opponentID)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        ChatModel model = ChatModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        model.id = querySnapshot.docs.first.id;
        return model;
      } else {
        //create new chat room
        addChatRoom(ChatModel(
          opponentID: opponentID,
          priority: "Low",
        ));
        return openChatRoom(opponentID);
      }
    } catch (e) {
      return ChatModel();
    }
  }

  //add new chat room with return id
  static Future<String> addChatRoom(ChatModel chatRoom) async {
    try {
      //add chat room at user and seller side
      DocumentReference documentReference = await getUserDocument()
          .collection(chatFolderName)
          .add(chatRoom.toJson());
      //set to seller side also
      await _sellerCollection
          .doc(chatRoom.opponentID)
          .collection(chatFolderName)
          .doc(documentReference.id)
          .set({
        "opponentID": AuthRepo.getCurrentUserId(),
        "priority": "Low",
      });
      return "Chat Room Added: ${documentReference.id}";
    } catch (e) {
      return e.toString();
    }
  }
}
