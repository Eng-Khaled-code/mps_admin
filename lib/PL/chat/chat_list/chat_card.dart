import 'package:finalmpsadmin/PL/utilites/helper/helper.dart';
import 'package:finalmpsadmin/models/chat_model.dart';
import 'package:finalmpsadmin/models/user_model.dart';
import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:flutter/material.dart';
import '../chat_page/chat_pge.dart';


class ChatCard extends StatelessWidget {
  const ChatCard(
      {Key? key,
      this.adminId,
      this.userModel,
      this.chatChange,
      this.lastMessage,
      this.unSeenMessagesCount})
      : super(key: key);

  final String? adminId;
  final UserModel? userModel;
  final ChatChange? chatChange;
  final ChatModel? lastMessage;
  final int? unSeenMessagesCount;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ListTile(
            onTap: () => onTap(context),
            leading: image(),
            title:
                Text(userModel!.fName + " " + userModel!.lName, maxLines: 1),
            subtitle: lastMessageWidget(width),
            trailing: unSeenMessagesCountWidget(width: width)),
        Divider()
      ],
    );
  }

  Widget lastMessageWidget(double width) {
    String firstPart = lastMessage == null
        ? ""
        : lastMessage!.idFrom == adminId
            ? "أنت: "
            : userModel!.fName + ": ";

    return lastMessage == null
        ? Align(
            alignment: Alignment.bottomRight,
            child: Container(
                width: width * .02,
                height: width * .02,
                child: CircularProgressIndicator(
                  strokeWidth: .7,
                )))
        : Container(
            child: Text(
              firstPart + lastMessage!.content,
              maxLines: 2,
              style: TextStyle(
                  fontSize: width * .03,
                  color: lastMessage!.seen == "no"
                      ? Colors.green
                      : Colors.black54),
            ),
          );
  }

  Widget unSeenMessagesCountWidget({double? width}) {
    return CircleAvatar(
      backgroundColor: (unSeenMessagesCount !=null&&unSeenMessagesCount!=0)?Colors.green:Colors.transparent,
              child: unSeenMessagesCount == null
                  ?
              CircularProgressIndicator(strokeWidth: .7)
                  :
              unSeenMessagesCount == 0
                  ?
              Container(color: Colors.transparent,):Text(
                  unSeenMessagesCount! > 99
                      ? "+99"
                      : unSeenMessagesCount.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: unSeenMessagesCount! > 9
                          ? width! * .034
                          : unSeenMessagesCount! > 99
                              ? width! * .028
                              : width! * .04)),
            );
  }

  onTap(BuildContext context) async {

    Helper().goTo(
        context: context,
        to: ChatPage(
            userId: userModel!.id,
            userAvatar: userModel!.imageUrl,
            userName: userModel!.fName+userModel!.lName,
            adminId: adminId));


    String chatId = userModel!.id + "&" + adminId!;

    if (!await chatChange!.openChatPage(chatId: chatId, userId: adminId)) {
      await chatChange!
          .firstOpenOrClose(open: "yes", chatId: chatId, userId: adminId);
    }
    chatChange!.loadUserOpensMyChatPage(
        chatId: chatId, userId: userModel!.id);
    chatChange!.loadConnectStatus(userModel!.id);
    chatChange!.updateToSeen(
        chatId: chatId, userId: userModel!.id);

  }

  Stack image() {
    return Stack(children: [
      CircleAvatar(
          backgroundImage: NetworkImage(userModel!.imageUrl), radius: 20),
      userModel!.connected == "no"
          ? Container(
              width: 0,
              height: 0,
            )
          : Positioned(
              left: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 10,
                  height: 10,
                  color: Colors.green,
                ),
              ))
    ]);
  }
}
