import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flame_firebase/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addUserData(UserModel userData) async {
    print(userData.uid);
    await _db.collection("users").doc(userData.uid).set(userData.toMap());
  }

  Future<UserModel> retrieveUserData(String docId) async {
    print(docId);
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("users").doc(docId).get();
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  Future<String> retrieveUserName(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("users").doc(user.uid).get();
    if (snapshot.exists)
      return snapshot.data()!["displayName"];
    else
      return "Unknown Player";
  }

  Stream<UserModel> listenUserData(String docId) {
    return _db.collection("users").doc(docId).snapshots().map(
          (snapshot) => UserModel.fromDocumentSnapshot(snapshot),
        );
  }
}
