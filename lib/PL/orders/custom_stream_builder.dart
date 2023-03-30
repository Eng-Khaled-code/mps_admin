import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/missed_model.dart';
import 'package:finalmpsadmin/PL/orders/order_card/order_card.dart';
import 'package:finalmpsadmin/models/user_model.dart';
import 'package:finalmpsadmin/provider/missed_change.dart';
import 'package:provider/provider.dart';

import '../utilites/helper/helper.dart';
import '../utilites/strings.dart';
import '../utilites/widgets/no_data_card.dart';

class CustomStreemBuilder extends StatelessWidget {
  Stream<QuerySnapshot>? stream;
  String? page;
  String? adminId;
  String? chatButton;

  CustomStreemBuilder({this.stream, this.page, this.adminId, this.chatButton});
  String? screenSizeDesign;
  @override
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);

    screenSizeDesign = Helper().getDesignSize(context);
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {

          return !snapshot.hasData || missedChange.users == null
              ? Center(
              child: CircularProgressIndicator(
              ))
              : snapshot.data!.size == 0
              ? NoDataCard(
              msg: page == "suggest"
                  ? "لا توجد إقتراحات في الوقت الحالي"
                  : "لا توجد طلبات")
              : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 5,
                  childAspectRatio:
                  screenSizeDesign == Strings.smallDesign
                      ? 0.6
                      : 0.7,
                  maxCrossAxisExtent:
                  screenSizeDesign == Strings.smallDesign
                      ? width
                      : width * .4),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, position) {
                UserModel userData = missedChange.getUserModel(
                    snapshot.data!.docs[position][MissedModel.USER_ID]);
               MissedModel missedModel=MissedModel.fromSnapshoot(snapshot.data!.docs[position].data() as Map<String,dynamic>);
                return userData == null ? Container() : OrderCard(
                    adminId: adminId!,
                    userId: userData.id,
                    userName: userData.fName + " " + userData.lName,
                    profileUrl: userData.imageUrl,
                    type: page!,
                    chatButton: chatButton!,
                  missedModel: missedModel,

                );
              },
              shrinkWrap
                  :
              true
          );
        });
  }

}