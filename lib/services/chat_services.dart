import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalmpsadmin/models/chat_model.dart';
import 'package:finalmpsadmin/models/missed_model.dart';
import 'package:finalmpsadmin/models/user_model.dart';

class ChatServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteMyMessage({String? messageId, String? docId}) async {
    await _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  Future<ChatModel> loadLastMessage({String? docId}) async {
    ChatModel _message = ChatModel();
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("chat")
          .doc(docId)
          .collection("messages")
          .get();

      _message = ChatModel.fromSnapshoot(querySnapshot.docs.last);
    } catch (ex) {}
    return _message;
  }

  Future<int> loadUnSeenMessagesCount({String? docId, String? userId}) async {
    int _count;

    QuerySnapshot querySnapshot = await _firestore
        .collection("chat")
        .doc(docId)
        .collection("messages")
        .where(ChatModel.ID_FROM, isNotEqualTo: userId)
        .where(ChatModel.SEEN, isEqualTo: "no")
        .get();

    _count = querySnapshot.docs.length;

    return _count;
  }

  addMessage({String? chatId, String? userId, String? message, String? seen}) {
//the chat id is the user id because the user send the messages to all admins
    String messageID = DateTime.now().millisecondsSinceEpoch.toString();

    var docRef = _firestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .doc(messageID);

    _firestore.runTransaction((transaction) {
      transaction.set(docRef, {
        "idFrom": userId,
        "timestanp": messageID,
        "content": message,
        "seen": seen,
        "message_id": messageID
      });
      return Future.delayed(Duration(minutes: 0));
    });
  }

// i want the admins that they responsible for my orders and checks if they opens chat at least one time
  Future<List<String>> loadMyUsers(String? userId) async {
    List<String> _usersIds = [];

    //getting  missed orders and my be missed orders that they are not in the waitting list
    await _firestore
        .collection(MissedModel.REF)
        .where(MissedModel.ADMIN_ID, isEqualTo: userId)
        .get()
        .then((snapshot1) {
      snapshot1.docs.forEach((element) async {
        //getting admins id that they responsible for my orders
        if (!_usersIds.contains(element.get(UserModel.ID)))
          _usersIds.add(element.get(UserModel.ID));
      });
    });

    return _usersIds;
  }

  Future<String> loadConnectStatus(String? adminId) async {
    String _connected = "";

    await _firestore.collection("users").doc(adminId).get().then((value) {
      _connected = value.data()!["connected"];
    });

    return _connected;
  }

  Future<String> loadUserOpensMyChatPage(String? chatId, String? userId) async {
    String _opened = "";

    try {
      await _firestore.collection("chat").doc(chatId).get().then((value) {
        _opened = value.data()![userId! + " open"];
      });
    } catch (ex) {
      _opened = "no";
    }
    return _opened;
  }

  Future<void> firstOpenOrCloseChatPage(
      {String? docId, String? userId, String? open}) async {
    await _firestore
        .collection("chat")
        .doc(docId)
        .set({userId! + " open": open});
  }

  Future<void> firstMessage({String? docId, String? open}) async {
    await _firestore.collection("chat").doc(docId).set({"open": open});
  }

  Future<void> UserWriteStatus({String? docId, String? open}) async {
    await _firestore.collection("chat").doc(docId).update({"open": open});
  }

  Future<void> updateOpenOrCloseChatPage(
      {String? docId, String? userId, String? open}) async {
    await _firestore
        .collection("chat")
        .doc(docId)
        .update({userId! + " open": open});
  }

  Future<void> updateToSeen({String? chatId, String? userId}) async {
    await _firestore
        .collection("chat")
        .doc(chatId)
        .collection("messages")
        .where(ChatModel.ID_FROM, isEqualTo: userId)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await _firestore
            .collection("chat")
            .doc(chatId)
            .collection("messages")
            .doc(element.id)
            .update({ChatModel.SEEN: "yes"});
      });
    });
  }

// Future<void> updateRecentMessaagesCount({String userId, String date}) async {
//   await _firestore.collection("chat").get().then((snapshot) async {
//     snapshot.docs.forEach((element) async {
//       String subString = element.id.substring(0, userId.length);

//       if (element.id != userId && userId == subString) {
//         if (int.tryParse(date) > 0) {
//           await _firestore
//               .collection("chat")
//               .doc(element.id)
//               .collection(element.id)
//               .where(ChatModel.ID_FROM, isNotEqualTo: userId)
//               .where(ChatModel.TIMESTANP, isGreaterThan: date)
//               .get()
//               .then((snapshot) async {
//             await _firestore
//                 .collection("chat")
//                 .doc(userId)
//                 .get()
//                 .then((value) async {
//               int oldCount = 0;
//               oldCount = value.data()["recentMessagesCount"];

//               await _firestore.collection("chat").doc(userId).update(
//                   {"recentMessagesCount": oldCount + snapshot.docs.length});
//             });
//           });
//         } else if (int.tryParse(date) == 0) {
//           await _firestore
//               .collection("chat")
//               .doc(element.id)
//               .collection(element.id)
//               .where(ChatModel.ID_FROM, isNotEqualTo: userId)
//               .get()
//               .then((value) async {
//             await _firestore.collection("chat").doc(userId).set(
//                 {"recentMessagesCount": value.docs.length, "last_date": 0});
//           });
//         }
//       }
//     });
//   });
// }

// Future<int> loadRecentMessagesCount({String userId}) async {
//   int _count = 0;
//   DocumentSnapshot documentSnapshot =
//       await _firestore.collection("chat").doc(userId).get();

//   _count = documentSnapshot.data() == null
//       ? 0
//       : documentSnapshot.data()["recentMessagesCount"];

//   return _count;
// }

// Future<String> loadLastDate({String userId}) async {
//   String _date = "";

//   DocumentSnapshot documentSnapshot =
//       await _firestore.collection("chat").doc(userId).get();

//   _date = documentSnapshot.data() == null
//       ? "0"
//       : documentSnapshot.data()["last_date"].toString();

//   return _date;
// }

// Future<void> updateLastDate({String userId}) async {
//   await _firestore.collection("chat").doc(userId).update(
//       {"last_date": DateTime.now().millisecondsSinceEpoch.toString()});
// }
}
