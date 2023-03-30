import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/missed_model.dart';

class SearchServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSuggestions(
      {String? collection, String? orderId, List<String>? ordersIds}) async {
    ordersIds!.forEach((element) async {
      await _firestore
          .collection(collection!)
          .doc(orderId)
          .collection("suggest")
          .doc(element)
          .set({"its_order_id": element, "suggest_true": "yes"});
    });
  }

  Future<List<String>> loadSuggestedOrdersId({String? orderId}) async {
    List<String> _ordersIds = ["no orders"];
    await _firestore
        .collection(MissedModel.REF)
        .doc(orderId)
        .collection("suggest")
        .where("suggest_true", isEqualTo: "yes")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        //getting admins id that they responsible for my orders
        _ordersIds.add(element.get("its_order_id"));
      });
    });

    return _ordersIds;
  }

//
//  Future<List<MissedModel>> loadAcceptedOrders({String type}) async {
//
//    List<MissedModel> _missed=[];
//    await _firestore
//        .collection(MissedModel.REF)
//        .where(MissedModel.TYPE, isEqualTo: type)
//        .where(MissedModel.STATUS, isEqualTo: "1").get().then((snapshot){
//
//      snapshot.docs.forEach((element) async {
//        //getting admins id that they responsible for my orders
//
//        MissedModel missedModel=MissedModel.fromSnapshoot(element);
//        _missed.add(missedModel);
//      });
//
//    });
//
//    return _missed;
//  }
//
//
//
//  Future<List<String>> loadRepetedOrders({List<String> ordersIds,String orderId}) async {
//    List<String> _repetedOrdersIds=[];
//    await _firestore
//        .collection(MissedModel.REF).doc(orderId).collection("suggest").where("its_order_id",whereIn: ordersIds)
//       .get().then((snapshot){
//
//
//      snapshot.docs.forEach((element) async {
//
//        //getting admins id that they responsible for my orders
//        _repetedOrdersIds.add(element.get("its_order_id"));
//      });
//
//    });
//
//    return _repetedOrdersIds;
//  }
//
//
//
}
