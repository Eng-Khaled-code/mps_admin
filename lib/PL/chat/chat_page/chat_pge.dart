import 'package:flutter/material.dart';
import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:provider/provider.dart';

import 'chat_app_bar.dart';
import 'chat_body.dart';

class ChatPage extends StatelessWidget {
  final String? userId;
  final String? adminId;
  final String? userAvatar;
  final String? userName;

  ChatPage(
      {@required this.userId,
        @required this.userAvatar,
        @required this.userName,
        @required this.adminId});

final TextEditingController messageEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    ChatChange chat = Provider.of<ChatChange>(context);

    return Scaffold(
      appBar: ChatAppBar(
        userAvatar: userAvatar,
        userName: userName,
        userOpensChatPage: chat.getOpensMyChatPage,
        connectStatus: chat.getConnectStatus,
        chatChange: chat,
        chatId: userId!+"&"+adminId!,
      ),
      body: ChatScreenBody(
          userId: userId, adminId: adminId, chatChange: chat,messageEditingController: messageEditingController,),
    );
  }
}
