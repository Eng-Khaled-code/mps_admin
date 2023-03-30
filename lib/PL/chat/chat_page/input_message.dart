import 'package:finalmpsadmin/provider/chat_change.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class InputMessage extends StatelessWidget {
   InputMessage({Key? key ,
     this.userId,this.adminId,
     this.listScrollController,this.messageEditingController}) : super(key: key);

  final FocusNode focusNode = FocusNode();
  final String? userId;
  final String? adminId;
   final ScrollController? listScrollController;
   final TextEditingController? messageEditingController;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          width: double.infinity,
          height: 70.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ))),
          child: Row(
            children: <Widget>[
              //text Felid message
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    controller: messageEditingController,
                    focusNode: focusNode,
                    enableSuggestions: true,
                    decoration: InputDecoration.collapsed(
                        hintText: "اكتب هنا ...",
                        hintStyle: TextStyle(color: Colors.grey)),
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ),
              ),

              //sent button

              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.lightBlueAccent,
                    onPressed: ()async=> onSendMessage(context)),
              )
            ],
          ),
        ),
    );
    }


onSendMessage(BuildContext context) async {
      if (messageEditingController!.text != "") {
          ChatChange chatChange=Provider.of<ChatChange>(context,listen: false);
        chatChange.sendMessage(
            userId: adminId,
            message: messageEditingController!.text,
            chatID: userId! + "&" + adminId!,
            seen:chatChange.getOpensMyChatPage=="yes"&&chatChange.getConnectStatus=="yes"?"yes":"no" );
        messageEditingController!.clear();

        listScrollController!.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      } else {
        Fluttertoast.showToast(msg: "من فضلك إدخل رسالتك");
      }

}




     }
