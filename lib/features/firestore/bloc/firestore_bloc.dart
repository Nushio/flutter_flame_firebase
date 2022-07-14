import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_flame_firebase/features/firestore/firestore_repository_impl.dart';
import 'package:flutter_flame_firebase/models/user_model.dart';

part 'firestore_event.dart';
part 'firestore_state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  final FirestoreRepositoryImpl _firestoreRepository;
  FirestoreBloc(this._firestoreRepository) : super(FirestoreInitial()) {
    on<FirestoreFetchUserDoc>(_fetchUserData);
    // on<FirestoreListenUserDoc>(_listenUserData);
  }

  _fetchUserData(
      FirestoreFetchUserDoc event, Emitter<FirestoreState> emit) async {
    try {
      UserModel userData =
          await _firestoreRepository.retrieveUserData(event.docId);
      emit(FirestoreSuccess(userData));
    } catch (e) {
      print(e);
      emit(FirestoreError());
    }
  }

  Stream<UserModel>? listenUserData(String docId) {
    try {
      Stream<UserModel> userData = _firestoreRepository.listenUserData(docId);
      return userData;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
