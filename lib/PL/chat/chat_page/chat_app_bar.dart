import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar(
      {Key? key,
      this.userOpensChatPage,
      this.connectStatus,
        this.chatId,
      this.userName,
      this.userAvatar,
      this.chatChange
      })
      : super(key: key);
  final String? connectStatus;
  final String? userName;
  final String? userOpensChatPage;
  final String? userAvatar;
  final ChatChange? chatChange;
  final String? chatId;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(userName!),
          connectStatus == "no"
              ? Container()
              : Text(
                  "متصل الان  ",
                  style: TextStyle(
                      fontSize: 11,
                      color: userOpensChatPage == "yes"
                          ? Colors.green
                          : Colors.grey),
                ),
        ],
      ),
      actions: [
        Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    CircleAvatar(backgroundImage: NetworkImage(userAvatar!)))),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        )
      ],
      leading: leading(),
      automaticallyImplyLeading: false,
    );
  }

  leading() {

    return  chatChange!.isLoading == true
    ? Center(
    child: Container(
    width: 23,
    height: 23,
    child: CircularProgressIndicator(
    strokeWidth: 1,
    )),
    )
        : IconButton(
    icon: Icon(
    chatChange!.icon,
    color: chatChange!.icon == Icons.lock_outline ? Colors.red : Colors.green,
    ),
    onPressed: () => controllUserInput()

    );
  }


  controllUserInput() async {
    chatChange!.setLoading(true);

    if (chatChange!.icon == Icons.lock_outline) {
      if (!await chatChange!.openChatSpeaking(chatId: chatId)) {
        await chatChange!.firstMessage(open: "1", chatId:chatId);
      }

      Fluttertoast.showToast(msg: "تم إعطاء المستخدم صلاحية الإرسال", toastLength: Toast.LENGTH_LONG);
    } else {
      if (!await chatChange!.notAllowUserToWrite(
          chatId:chatId)) {
        await chatChange!.firstMessage(
            open: "0", chatId: chatId);
      }
      Fluttertoast.showToast(msg: "تم قفل المحادثة", toastLength: Toast.LENGTH_LONG);
    }

    chatChange!.setIcon();

  }

}
