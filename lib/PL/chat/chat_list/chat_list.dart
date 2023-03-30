import 'package:finalmpsadmin/PL/utilites/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:finalmpsadmin/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/chat_model.dart';
import '../../utilites/widgets/no_data_card.dart';
import 'chat_card.dart';


class ChatList extends StatelessWidget {
  final String? userId;

  ChatList({this.userId});


  Map<String, ChatModel> lastMessagesMap = Map();
  Map<String, int> unSeenMessagesCountMap = Map();

  lastMessages(ChatChange chat) {
    if (chat.getMyUsersIds != null || chat.getMyUsersIds != []) {
      chat.getMyUsersIds!.forEach((element) async {
        //no admins element i put it for where filter and it is not admin id
        //and i must not use it becase he crachs the program
        if (element != "no users") {
          String _docId = element + "&" + userId!;
          ChatModel _chatModel = await chat.loadLastMessage(docId: _docId);

          lastMessagesMap[element] = _chatModel;
//
          int _count = await chat.loadUnSeenMessagesCount(
              docId: _docId, userId: userId);

          unSeenMessagesCountMap[element] = _count;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatChange chat = Provider.of<ChatChange>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    lastMessages(chat);
    return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar:AppBar(
              title: Text(
                  "تواصل مع المستخدمين",
                ),
            ),
            body: Container(
              child: Stack(
                children: <Widget>[
                  BackgroundImage(),
                  listBody(chat, width, height),
                ],
              ),
            ),
          ),
        );
  }

  Widget listBody(ChatChange chatChange, double width, double height) {
    return
      chatChange.getMyUsersIds==null
          ?
      Center(child: CircularProgressIndicator())
        :
    chatChange.getMyUsersIds!.isEmpty
        ?
    NoDataCard(msg: "حتي الان انت غير مسئول عن طلبات")
        :
    StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(UserModel.USER_REF)
                .where(UserModel.ID, whereIn: chatChange.getMyUsersIds)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.data!.size == 0
                      ? NoDataCard(msg: "حتي الان انت غير مسئول عن طلبات",)
                      : ListView.builder(
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, position) {
                            UserModel userModel =
                            UserModel.fromSnapshoot(
                                snapshot.data!.docs[position].data() as Map<String,dynamic>);
                            return ChatCard(
                              adminId: userId,
                              userModel: userModel,
                              chatChange: chatChange,
                              lastMessage:
                              lastMessagesMap[userModel.id],
                              unSeenMessagesCount:
                              unSeenMessagesCountMap[
                              userModel.id],
                            );
                          },
                          shrinkWrap: true);
            });
  }
}
