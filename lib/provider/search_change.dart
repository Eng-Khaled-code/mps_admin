import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/missed_model.dart';
import 'package:finalmpsadmin/services/search_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchChange with ChangeNotifier {
  bool isLoading = false;
  List<String> _suggestedOrdersIds = [];

  SearchChange.initialize();
  SearchServices _searchServices = SearchServices();

  setLoading(bool loading){
    isLoading=loading;
    notifyListeners();
  }

  Future<bool> suggest({String? orderId, List<String>? ordersIds}) async {
    try {
      // refuse order value 2
      await _searchServices
          .addSuggestions(
              collection: MissedModel.REF,
              orderId: orderId,
              ordersIds: ordersIds);

      Fluttertoast.showToast(msg: "تم إرسال الإقتراحات",toastLength: Toast.LENGTH_LONG);
      return true;
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!,toastLength: Toast.LENGTH_LONG);
      return false;
    }
  }

  Future<void> loadSuggestedOrdersIds({String? orderId}) async {
    _suggestedOrdersIds =
        await _searchServices.loadSuggestedOrdersId(orderId: orderId);

    notifyListeners();
  }

  List<String> get getSuggestedOrdersIds => _suggestedOrdersIds;
}
