import 'package:cloud_firestore/cloud_firestore.dart';

class NotifyServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotify({String? userId, Map<String, dynamic>? values}) async {
    await _firestore
        .collection("notify")
        .doc(userId)
        .collection("notifications")
        .doc(values!["notify_id"])
        .set(values);
  }

  Future<void> deleteOldNotifys({String? userId, String? orderId, type}) async {
    await _firestore
        .collection("notify")
        .doc(userId)
        .collection("notifications")
        .where("order_id", isEqualTo: orderId)
        .where("type", isEqualTo: type)
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        await _firestore
            .collection("notify")
            .doc(userId)
            .collection("notifications")
            .doc(element.get("notify_id"))
            .delete();
      });
    });
    ;
  }
}
