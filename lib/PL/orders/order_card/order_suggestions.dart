
import 'package:finalmpsadmin/PL/utilites/helper/helper.dart';
import 'package:finalmpsadmin/provider/notify_change.dart';
import 'package:finalmpsadmin/services/ml_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finalmpsadmin/provider/search_change.dart';
import 'package:provider/provider.dart';
import 'package:finalmpsadmin/models/missed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../chat/chat_page/chat_pge.dart';
import '../../utilites/text_style/text_styles.dart';
import '../../utilites/widgets/background_image.dart';
import '../../utilites/widgets/custom_alert_dialog.dart';
import '../../utilites/widgets/custom_button.dart';
import '../custom_stream_builder.dart';
import 'card_details.dart';


class OrderSuggestions extends StatelessWidget {

  final MissedModel? missedModel;
  final String? adminId;

  final String? userId;
  final String? userName;
  final String? profileUrl;

  OrderSuggestions(
      {@required this.missedModel,
      @required this.userId,
      @required this.adminId,
      @required this.userName,
      @required this.profileUrl,});
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    SearchChange searchChange = Provider.of<SearchChange>(context);
    searchChange.loadSuggestedOrdersIds(orderId: missedModel!.id);

    NotifyChange notifyChange = Provider.of<NotifyChange>(context);
    double height=MediaQuery.of(context).size.height;

    textStyle=Theme.of(context).colorScheme.background == Color(0xff90caf9)?TextStyle(color:Colors.black):TextStyle(color:Colors.white);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            Navigator.pop(context);

            return true;
          },
          child: Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => navigateToChatPage(context),
              label: Text("التوتصل مع الناشر"),
            ),
            appBar: AppBar(
              title: Text(
                "التفاصيل و الاقتراحات",
              )
            ),
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                BackgroundImage(),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        topImage(height),
                        userRow(),
                        CardDetailsTable(missedModel: missedModel),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: searchChange.isLoading == true
                              ? Container()
                              : CustomButton(
                                  text:
                                      searchChange.getSuggestedOrdersIds == []
                                          ? "عذرا لا توجد لدينا طلبات حاليا"
                                          : "بحث",
                                  onPress: () {
                                    searchChange.getSuggestedOrdersIds == []
                                        ? () {}
                                        : search(context, searchChange,
                                            notifyChange);
                                  },
                                ),
                        ),
                        Text(
                          "الأقتراحات",
                          style: TextStyles.title,
                        ),
                        SizedBox(height: 20),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: searchChange.isLoading ||
                                searchChange.getSuggestedOrdersIds.isEmpty
                                ? Center(child: CircularProgressIndicator())
                                : CustomStreemBuilder(
                                adminId: adminId,
                                stream: FirebaseFirestore.instance
                                    .collection(MissedModel.REF)
                                    .where(MissedModel.ID,
                                    whereIn: searchChange
                                        .getSuggestedOrdersIds)
                                    .snapshots(),
                                page: "suggest",chatButton: "main",)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  search(BuildContext context, SearchChange searchChange,
      NotifyChange notifyChange) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
              title: "تنبيه",
            text: "بدأ عملية البحث",

            onPress: () async {
              Navigator.pop(context);
              searchChange.setLoading(true);

              String imageName = missedModel!
                  .imageUrl
                  .split("/")
                  .last;

              MlServices mlServices = MlServices();
              Map<String, dynamic> resultMap =
              await mlServices.getSuggestions(imageName);

              String result = resultMap["result"];
              String condition = resultMap["status"];
              if (condition == "1") {
                result = result
                    .split(".")
                    .first;
                if (await searchChange.suggest(
                    orderId: missedModel!.id, ordersIds: [result]))
                  sendNotification(notifyChange);
              } else if (condition == "0") {
                Fluttertoast.showToast(
                    msg: resultMap["result"], toastLength: Toast.LENGTH_LONG);
              } else if (condition == "3") {
                Fluttertoast.showToast(msg: "غير موجود في قواعد البيانات",
                    toastLength: Toast.LENGTH_LONG);
              }
              searchChange.setLoading(false);

            }));
  }

  navigateToChatPage(BuildContext context) async {
    Helper().goTo(context:context,to:ChatPage(
                      userName: userName,
                      userId: userId,
                      userAvatar: profileUrl,
                      adminId: adminId,
                    ));

  }

  topImage(double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey.withOpacity(.3),
              width: 4),
        ),
        width: double.infinity,
        height: height * .3,
        child: Image.network(
          missedModel!.imageUrl,
          fit: BoxFit.fill,
          errorBuilder: (context, object, stackTrace) =>
              Image.asset(
                "assets/images/errorimage.png",
                fit: BoxFit.fill,
              ),
        ),
      ),
    );
  }

  Padding userRow() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          profileUrl == "no image"
              ? Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 30,
          )
              : CircleAvatar(backgroundImage: NetworkImage(profileUrl!),radius: 30,),

          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${userName}"),
              Text(DateTime.fromMillisecondsSinceEpoch(int.tryParse(missedModel!.publishDate)!).toString())
            ],
          )
        ],
      ),
    );
  }

  void sendNotification(NotifyChange notifyChange) async{
    String notifyID =
    DateTime.now().millisecondsSinceEpoch.toString();
    //add notification to user
    await notifyChange
        .addNotify(userId: userId, values: {
      "notify_id": notifyID,
      "user_id": userId,
      "order_id": missedModel!.id,
      "image_url": missedModel!.imageUrl,
      "order_name": missedModel!.name,
      "opened": "no",
      "type": "suggest",
      "reason": "",
      "datetime": notifyID
    });
  }
}
