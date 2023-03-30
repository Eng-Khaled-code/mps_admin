
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../../../provider/missed_change.dart';
import '../../../../../provider/notify_change.dart';
import '../../../models/missed_model.dart';
import '../../../services/notify_services.dart';
import '../../chat/chat_page/chat_pge.dart';
import '../../utilites/helper/helper.dart';
import '../../utilites/widgets/cancel_button.dart';
import '../../utilites/widgets/custom_button.dart';
import 'order_suggestions.dart';

class CardBottomSheet extends StatelessWidget {
  const CardBottomSheet({Key? key,this.missedModel,this.missedChange,this.type,this.chatButton,this.profileUrl,this.userId,this.adminId,this.userName}) : super(key: key);

  final MissedChange? missedChange;
  final MissedModel? missedModel;
  final String? type;
  final String?chatButton;
  final String? adminId;
  final String? userId;
  final String? userName;
  final String? profileUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("ما الذي تريد فعله بهذا الطلب؟"),
        ),Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "الموافقة",
              onPress: () => navigateToSuggestionPage(context),),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "رفض الطلب",
              onPress: () => showDialogReasonDialog(context),),
        ),
        chatButton == "main"
            ? Container()
            : Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "التواصل مع الناشر",
              onPress: () => navigateToChatPage( context)),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: CustomButton(
              text: "إغلاق",
              onPress: () => Navigator.pop(context),
             ),
        ),
      ],
    );
  }


  navigateToSuggestionPage(BuildContext context) async {

        if (missedModel!.status != "1") {
              //if first accept
              if (await missedChange!.acceptOrder(id: missedModel!.id, adminId: adminId))
                  goToSuggetionPage(context);

              sendNotificationToUser("refuse",context,"");
        } else {
              goToSuggetionPage(context);
        }

  }
  goToSuggetionPage(BuildContext context){

    if (type == "missed") {
      Helper().goTo(context:context,to:OrderSuggestions(
        userId: userId,
        profileUrl: profileUrl,
        userName: userName,
        adminId: adminId,
        missedModel: missedModel,
      ));
    } else {
      Navigator.pop(context);
    }
  }


  navigateToChatPage(BuildContext context) async {
    Helper().goTo(context:context ,to: ChatPage(
                  userName: userName,
                  userId: userId,
                  userAvatar: profileUrl,
                  adminId: adminId,
                ));
  }

  showDialogReasonDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController();
    if (missedModel!.status == "2") {
      Fluttertoast.showToast(
          msg: "هذا الطلب مرفوض بالفعل", toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            MissedChange missedChange = Provider.of<MissedChange>(context);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text("السبب ؟"),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return "يجب ان تدخل سبب رفض هذا الطلب";
                    },
                    decoration: InputDecoration(
                        labelText: "السبب",
                        labelStyle: TextStyle(fontSize: 13)),
                  ),
                ),
                actions: <Widget>[
                  missedChange.isLoading
                      ? Center(
                      child: CircularProgressIndicator(strokeWidth: 0.7))
                      : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          refuseOrder(missedChange, context, missedModel!.status,
                              _controller.text);
                        }
                      },
                      child: Text("إرسال الرفض",
                          style:
                          TextStyle(fontSize: 13, color: Colors.red))),
                  CancelButton(),
                ],
              ),
            );
          });
    }
  }

  refuseOrder(MissedChange missedChange, BuildContext context, String? status,
      String reason) async {

    if (await missedChange.refuseOrder(id: missedModel!.id, adminId: adminId))
    {

      Navigator.pop(context);
      sendNotificationToUser("accept",context,reason);
    }

  }

  void sendNotificationToUser(String type,BuildContext context,String reason) async{

    NotifyChange notifyChange = Provider.of<NotifyChange>(context, listen: false);

    String notifyID = DateTime.now().millisecondsSinceEpoch.toString();
    //if there are refused notify for this order i will delete it
    await NotifyServices()
        .deleteOldNotifys(orderId: missedModel!.id, userId: userId, type:type );

    //add notification to user
    await notifyChange.addNotify(userId: userId, values: {
      "notify_id": notifyID,
      "user_id": userId,
      "order_id": missedModel!.id,
      "image_url": missedModel!.imageUrl,
      "order_name": missedModel!.name,
      "opened": "no",
      "type": type,
      "reason": reason,
      "datetime": notifyID
    });



  }
}
