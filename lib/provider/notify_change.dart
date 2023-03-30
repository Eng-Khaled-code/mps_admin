import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/services/notify_services.dart';
import 'package:flutter/cupertino.dart';

class NotifyChange with ChangeNotifier {
  bool isLoading = false;

  NotifyChange.initialize();

  NotifyServices _notifyServices = NotifyServices();

  Future<void> addNotify({String? userId, Map<String, dynamic>? values}) async {
    try {
      isLoading = true;
      notifyListeners();

      // refuse order value 2
      await _notifyServices
          .addNotify(userId: userId, values: values)
          .then((value) {
        isLoading = false;
        notifyListeners();
      });
    } on FirebaseException catch (ex) {
      print(ex.message.toString());
      isLoading = false;
      notifyListeners();
    }
  }
}
