import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/user_model.dart';

class FirestoreServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFirestore(
      {String? collection, String? docId, Map<String, dynamic>? data}) async {
    await _firestore.collection(collection!).doc(docId).set(data!);
  }

  Future<void> updateToFirestore(
      {String? collection, String? docId, Map<String, dynamic>? data}) async {
    await _firestore.collection(collection!).doc(docId).update(data!);
  }

  Future<void> deleteFromFirestore({String? collection, String? docId}) async {
    await _firestore.collection(collection!).doc(docId).delete();
  }

  Future<UserModel> loadUserInformation(String userID) async {
    UserModel? user ;

    DocumentSnapshot<Map<String, dynamic>>? snapshot =
    await _firestore.collection(UserModel.USER_REF).doc(userID).get();
    user = UserModel.fromSnapshoot(snapshot.data());
    return user;
  }

  Future<List<UserModel>> loadUsers() async {
    List<UserModel> users = [];

    await _firestore
        .collection(UserModel.USER_REF)
        .where("type", isEqualTo: "user")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        UserModel userModel = UserModel.fromSnapshoot(element.data());

        users.add(userModel);
      });
    });

    return users;
  }


}
