import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:finalmpsadmin/services/firestore_services.dart';
import 'package:finalmpsadmin/models/missed_model.dart';
import 'package:finalmpsadmin/models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MissedChange with ChangeNotifier {
  bool isLoading = false;
  FirestoreServices _firestoreServices = FirestoreServices();

  List<UserModel> _users = [];

  MissedChange.initialize() {
    loadUsers();
  }

  loadUsers() async {
    _users = await _firestoreServices.loadUsers();
    notifyListeners();
  }

  UserModel getUserModel(String adminId) {
    UserModel _userModel = UserModel();
    users.forEach((element) {
      if (element.id == adminId) {
        _userModel = element;
      }
    });

    return _userModel;
  }

  List<UserModel> get users => _users;

  Future<bool> refuseOrder({String? id, String? adminId}) async {
    try {
      isLoading = true;
      notifyListeners();

      // refuse order value 2
      await _firestoreServices.updateToFirestore(
          collection: MissedModel.REF,
          docId: id,
          data: {
            MissedModel.STATUS: "2",
            MissedModel.ADMIN_ID: adminId
          });

        isLoading = false;
        notifyListeners();

      Fluttertoast.showToast(
          msg: "تم رفض الطلب", toastLength: Toast.LENGTH_LONG);
      return true;
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!,toastLength: Toast.LENGTH_LONG);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> acceptOrder({String? id, String? adminId}) async {
    try {
      isLoading = true;
      notifyListeners();

      // accept order value 1
      await _firestoreServices.updateToFirestore(
          collection: MissedModel.REF,
          docId: id,
          data: {
            MissedModel.STATUS: "1",
            MissedModel.ADMIN_ID: adminId
          });

        isLoading = false;
        notifyListeners();

      Fluttertoast.showToast(
          msg: "تمت الموافقة علي الطلب",
          toastLength: Toast.LENGTH_LONG);
      return true;
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!,toastLength: Toast.LENGTH_LONG);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
