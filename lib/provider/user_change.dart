
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:finalmpsadmin/PL/auth/log_in.dart';
import 'package:finalmpsadmin/models/user_model.dart';
import 'package:finalmpsadmin/services/firestore_services.dart';
import 'package:finalmpsadmin/services/storage_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserChange with ChangeNotifier {
  FirebaseAuth _firebaseAuth;

  FirestoreServices firestoreServices = FirestoreServices();
  StorageServices storageServices = StorageServices();

  bool isLoading = false;
  bool isImageLoading = false;

  //status variables
  Status status = Status.Uninitialized;
  UserModel? userData;

//main constractor
  UserChange.initialize() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen(onStatusChange);
  }

  Future<void> onStatusChange(User? user) async {
    if (user == null)
      status = Status.Unauthenticated;
    else {
      await updateConnectStatus(connected: "yes", userId: user.uid);
      //on sign in or up orany authentication operation happen the user information will be gotten
      userData = await firestoreServices.loadUserInformation(user.uid);
      Fluttertoast.showToast(msg: "sign in successfully");
      status = Status.Authenticated;

    }
    notifyListeners();
  }


  Future<void> updateUserName({String? fName, String? lName}) async {
    try {
      isLoading = true;
      notifyListeners();

      await firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userData!.id,
          data: {UserModel.F_NAME: fName, UserModel.L_NAME: lName});

      userData = await firestoreServices.loadUserInformation(userData!.id);
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: "تم تعديل الاسم بنجاح");
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  Future<void> updateConnectStatus({String? connected, String? userId}) async {
    try {
      await firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userId ?? userData!.id,
          data: {UserModel.CONNECTED: connected});
      notifyListeners();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  Future<void> updateUserField({String? field, String? value}) async {
    try {
      isLoading = true;
      notifyListeners();
      await firestoreServices.updateToFirestore(
          collection: UserModel.USER_REF,
          docId: userData!.id,
          data: {field!: value});

      userData = await firestoreServices.loadUserInformation(userData!.id);
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: "تم التعديل بنجاح");
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  Future<void> updateProfilePicture({File? imageFile}) async {
    try {
      isImageLoading = true;
      notifyListeners();

      await storageServices.uploadingImageToStorage(
          docId: userData!.id,
          collection: UserModel.USER_REF,
          image: imageFile,
          fieldName: UserModel.IMAGE_URL,
          storageDirectoryPath: UserModel.DIRECTORY,
          type: "update");

      userData = await firestoreServices.loadUserInformation(userData!.id);
      isImageLoading = false;
      Fluttertoast.showToast(msg: "تم تعديل رقم الصورة بنجاح");
      notifyListeners();

    } on FirebaseException catch (e) {
      isImageLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message!);
    }
  }
  // sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      status = Status.Authenticating;
      notifyListeners();

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(UserModel.USER_REF)
          .where(UserModel.EMAIL, isEqualTo: email)
          .where(UserModel.TYPE, isEqualTo: "admin")
          .get();
      final List<DocumentSnapshot> querySnapshotResultList = querySnapshot.docs;

      //saving data to firestore becase this user is new
      if (querySnapshotResultList.length != 0) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        status = Status.Authenticated;
        notifyListeners();
      } else {
        status = Status.Unauthenticated;
        Fluttertoast.showToast(msg: "هذا الإيميل ليس لمسئول",toastLength: Toast.LENGTH_LONG);
        notifyListeners();
      }
    } on FirebaseException catch (ex) {
      status = Status.Unauthenticated;
      Fluttertoast.showToast(msg: ex.message!,toastLength: Toast.LENGTH_LONG);
      notifyListeners();
    }
  }

//sign out for all
  Future<void> signOut() async {
    status = Status.Authenticating;
    notifyListeners();
    try {
      await _firebaseAuth.signOut();
      await updateConnectStatus(connected: "no", userId: userData!.id);

      status = Status.Unauthenticated;
      notifyListeners();
    } catch (ex) {
      status = Status.Authenticated;
      notifyListeners();
    }
  }
}
