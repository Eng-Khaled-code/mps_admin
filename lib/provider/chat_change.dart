import 'package:finalmpsadmin/models/chat_model.dart';
import 'package:finalmpsadmin/services/chat_services.dart';
import 'package:flutter/material.dart';

class ChatChange with ChangeNotifier {
  ChatChange.initialize();

  bool isLoading=false;
  ChatServices _chatServices = ChatServices();
  List<String>? _usersIds;
  String _connectStatus = "";
  String _opensChatPage = "";
  IconData icon = Icons.lock_outline;

  setIcon(){
    icon =
    (icon == Icons.lock_outline) ? Icons.lock_open : Icons.lock_outline;

    isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(
      {String? userId, String? chatID, String? message, String? seen}) async {
    await _chatServices.addMessage(
        chatId: chatID, message: message, userId: userId, seen: seen);
    notifyListeners();
  }

  setLoading(bool loading){
    isLoading=loading;
    notifyListeners();
  }

  Future<void> loadConnectStatus(String? adminId) async {
    _connectStatus = await _chatServices.loadConnectStatus(adminId);
    notifyListeners();
  }

  Future<void> loadMyUsersId(String? userId) async {
    _usersIds = await _chatServices.loadMyUsers(userId);
    notifyListeners();
  }

//open is 1
  Future<bool> openChatSpeaking({String? chatId}) async {
    try {
      await _chatServices.UserWriteStatus(docId: chatId, open: "1");

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> notAllowUserToWrite({String? chatId}) async {
    try {
      await _chatServices.UserWriteStatus(docId: chatId, open: "0");

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<void> firstMessage({String? open, String? chatId}) async {
    await _chatServices.firstMessage(docId: chatId, open: open);
  }

  Future<ChatModel> loadLastMessage({String? docId}) async {
    ChatModel _chatModel = await _chatServices.loadLastMessage(docId: docId);

    notifyListeners();
    return _chatModel;
  }

  Future<int> loadUnSeenMessagesCount({String? docId, String? userId}) async {
    int _count = await _chatServices.loadUnSeenMessagesCount(
        docId: docId, userId: userId);

    notifyListeners();
    return _count;
  }

  Future<void> updateToSeen({String? chatId, String? userId}) async {
    try {
      // refuse order value 2
      await _chatServices
          .updateToSeen(chatId: chatId, userId: userId)
          .then((value) {
        notifyListeners();
      });
    } catch (ex) {
      notifyListeners();
    }
  }

//open is yes
  Future<bool> openChatPage({String? chatId, String? userId}) async {
    try {
      await _chatServices.updateOpenOrCloseChatPage(
          docId: chatId, userId: userId, open: "yes");
      return true;
    } catch (ex) {
      return false;
    }
  }

//close is no

  Future<bool> closeChatPage({String? chatId, String? userId}) async {
    try {
      await _chatServices.updateOpenOrCloseChatPage(
          docId: chatId, userId: userId, open: "no");

      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<void> firstOpenOrClose(
      {String? chatId, String? userId, String? open}) async {
    await _chatServices.firstOpenOrCloseChatPage(
        docId: chatId, userId: userId, open: open);
  }

  Future<void> loadUserOpensMyChatPage({String? chatId, String? userId}) async {
    _opensChatPage =
        await _chatServices.loadUserOpensMyChatPage(chatId, userId);
    notifyListeners();
  }

  List<String> get getMyUsersIds => _usersIds!;

  String get getConnectStatus => _connectStatus;

  String get getOpensMyChatPage => _opensChatPage;
}
