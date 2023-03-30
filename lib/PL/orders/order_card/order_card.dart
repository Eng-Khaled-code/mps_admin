import 'package:finalmpsadmin/PL/orders/order_card/status_row.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:finalmpsadmin/provider/missed_change.dart';
import '../../../models/missed_model.dart';
import 'bottom_sheet.dart';
import 'card_details.dart';
import 'date_widget.dart';

class OrderCard extends StatelessWidget {
  final String? type;
  final MissedModel? missedModel;
  final String? adminId;
  final String? userId;
  final String? userName;
  final String? profileUrl;
  final String? chatButton;

  OrderCard({
    @required this.userId,
    @required this.userName,
    @required this.profileUrl,
    @required this.adminId,
    @required this.type,
    @required this.chatButton,
    @required this.missedModel
  });
 TextStyle? textStyle;
  Color? cardColor;
  settingColorsAndStyles(BuildContext context){
    if(Theme.of(context).colorScheme.background == Color(0xff90caf9))
    {
      textStyle=TextStyle(color: Colors.black);
      cardColor= Colors.white;
    }
    else
    {
      textStyle=TextStyle(color: Colors.white);
      cardColor= Colors.black;

    }
  }

  @override
  Widget build(BuildContext context) {
    MissedChange missedChange = Provider.of<MissedChange>(context);
    settingColorsAndStyles(context);
  return InkWell(
    onTap: () {
      if (type == "missed" || type == "mayBe")
        showCustomBottomSheet(context, missedChange);
    },
    child: Container(
      color: cardColor,

      child: Padding(
          padding: const EdgeInsets.all( 10.0),
          child: Column(
            children: [
             userDetailsRow(),
              SizedBox(height: 10.0),
              image(),
              SizedBox(height: 10.0),
              type == "suggest"
                  ? Container()
                  : StatusRow(
                status: missedModel!.status,
                textStyle: textStyle,
              ),
              CardDetailsTable(
                missedModel: missedModel,
                textStyle: textStyle,
              )
                    ],
                  ),
                ),
    ),
            );
  }

  ClipRRect image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/glow.gif',
        imageErrorBuilder: (e, r, t) => Image.asset(
          "assets/images/errorimage.png",
          fit: BoxFit.fill,
        ),
        image: missedModel!.imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.fill,
      ),
    );
  }

  showCustomBottomSheet(BuildContext context, MissedChange missedChange) {
    showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (context) {
          return CardBottomSheet(
              missedChange: missedChange, missedModel: missedModel,
              type: type,chatButton: chatButton,
             adminId: adminId,userId: userId,userName: userName,profileUrl: profileUrl,
          );
        });
  }

  Row userDetailsRow() {
    return  Row(
      children: [
        CircleAvatar(backgroundImage:NetworkImage(profileUrl!),radius: 30) ,
        SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$userName"),
            DateWidget(publishDate: missedModel!.publishDate,textStyle: textStyle),
          ],
        )
      ],
    );
  }
}