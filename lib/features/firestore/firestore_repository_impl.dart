import 'package:flutter_flame_firebase/features/firestore/firestore_service.dart';
import 'package:flutter_flame_firebase/models/user_model.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  FirestoreService service = FirestoreService();

  @override
  Future<void> saveUserData(UserModel user) {
    return service.addUserData(user);
  }

  @override
  Future<UserModel> retrieveUserData(String docId) {
    return service.retrieveUserData(docId);
  }

  @override
  Stream<UserModel> listenUserData(String docId) {
    return service.listenUserData(docId);
  }
}

abstract class FirestoreRepository {
  Future<void> saveUserData(UserModel user);
  Future<UserModel> retrieveUserData(String docId);
  Stream<UserModel> listenUserData(String docId);
}
