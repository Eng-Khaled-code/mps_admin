import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/missed_model.dart';
import 'package:provider/provider.dart';
import 'package:finalmpsadmin/provider/user_change.dart';
import '../custom_stream_builder.dart';

class OrdersAboutMissing extends StatelessWidget {
  String? responsibility;

  OrdersAboutMissing({this.responsibility});

  @override
  Widget build(BuildContext context) {
    UserChange user = Provider.of<UserChange>(context);
    return user.userData == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : CustomStreemBuilder(
            stream: setStream(user.userData!.id),
            page: "missed",
            adminId: user.userData!.id,
            chatButton: responsibility,
          );
  }

  Stream<QuerySnapshot> setStream(String userId) {
    return responsibility == "main"
        ? FirebaseFirestore.instance
        .collection(MissedModel.REF)
        .where(MissedModel.TYPE, isEqualTo: "فقد")
        .where(MissedModel.ADMIN_ID, isEqualTo: "")
        .snapshots()
        : responsibility == "الكل"
        ? FirebaseFirestore.instance
        .collection(MissedModel.REF)
        .where(MissedModel.ADMIN_ID, isEqualTo: userId)
        .where("type", isEqualTo: "فقد")
        .snapshots()
        : responsibility == "إنتظار"
        ? FirebaseFirestore.instance
        .collection(MissedModel.REF)
        .where(MissedModel.ADMIN_ID, isEqualTo: userId)
        .where("type", isEqualTo: "فقد")
        .where(MissedModel.STATUS, isEqualTo: "0")
        .snapshots()
        : responsibility == "مقبول"
        ? FirebaseFirestore.instance
        .collection(MissedModel.REF)
        .where(MissedModel.ADMIN_ID, isEqualTo: userId)
        .where("type", isEqualTo: "فقد")
        .where(MissedModel.STATUS, isEqualTo: "1")
        .snapshots()
        : FirebaseFirestore.instance
        .collection(MissedModel.REF)
        .where(MissedModel.ADMIN_ID, isEqualTo: userId)
        .where("type", isEqualTo: "فقد")
        .where(MissedModel.STATUS, isEqualTo: "2")
        .snapshots();
  }
}
