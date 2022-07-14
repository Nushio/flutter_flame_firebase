part of 'firestore_bloc.dart';

abstract class FirestoreEvent extends Equatable {
  const FirestoreEvent();

  @override
  List<Object?> get props => [];
}

class FirestoreFetchUserDoc extends FirestoreEvent {
  final String docId;
  const FirestoreFetchUserDoc(this.docId);
  @override
  List<Object?> get props => [docId];
}

class FirestoreListenUserDoc extends FirestoreEvent {
  final String docId;
  const FirestoreListenUserDoc(this.docId);
  @override
  List<Object?> get props => [docId];
}
