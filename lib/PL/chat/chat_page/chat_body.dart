import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/chat_model.dart';
import '../../../provider/chat_change.dart';
import '../../utilites/widgets/background_image.dart';
import 'input_message.dart';
import 'message.dart';

// ignore: must_be_immutable
class ChatScreenBody extends StatelessWidget {
  final String? userId;
  final String? adminId;
  final ChatChange? chatChange;
  final TextEditingController? messageEditingController;

  ChatScreenBody({
    @required this.userId,
    @required this.adminId,
    @required this.chatChange
    ,this.messageEditingController
  });

  final ScrollController listScrollController = ScrollController();

  var listMessages;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        await closeChatPage();

        return true;
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            BackgroundImage(),
            Column(
              children: <Widget>[
                listOfMessages(),
                InputMessage(
                    userId: userId,
                    adminId: adminId,
                    listScrollController: listScrollController,messageEditingController: messageEditingController,),
              ],
            ),
          ],
        ),
      ),
    );
  }

   closeChatPage() async {
    if (!await chatChange!.closeChatPage(chatId: userId! + "&" + adminId!, userId: adminId!)) {
      await chatChange!.firstOpenOrClose(
          open: "no",
          chatId: userId! + "&" + adminId!,
          userId: adminId!);
    }
  }

  Flexible listOfMessages() {
    return Flexible(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("chat")
                .doc(userId! + "&" + adminId!)
                .collection("messages")
                .orderBy("timestanp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.data!.docs.length == 0)
                return Center(
                    child: Text(
                      "لا توجد رسائل",
                      textAlign: TextAlign.center,
                    ));
              else {
                listMessages = snapshot.data!.docs;

                return ListView.builder(

                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    ChatModel chatModel =
                    ChatModel.fromSnapshoot(snapshot.data!.docs[index]);
                    bool isLastLeft = isLastMessageLeft(index),
                        isLastRight = isLastMessageRight(index);
                    return Message(
                        isLastMessLeft: isLastLeft,
                        isLastMessRight: isLastRight,
                        userId: userId,
                        adminId: adminId,
                        index: index,
                        chatChange: chatChange,
                        messagesLength: snapshot.data!.docs.length,
                        message: chatModel);
                  },
                  reverse: true,
                  controller: listScrollController,
                );
              }
            }));
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessages != null &&
        listMessages[index - 1]["idFrom"] != userId) ||
        index == 0)
      return true;
    else
      return false;
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessages != null &&
        listMessages[index - 1]["idFrom"] == userId) ||
        index == 0)
      return true;
    else
      return false;
  }


}
