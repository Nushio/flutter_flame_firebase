part of 'firestore_bloc.dart';

abstract class FirestoreState extends Equatable {
  const FirestoreState();

  @override
  List<Object?> get props => [];
}

class FirestoreInitial extends FirestoreState {}

class FirestoreSuccess extends FirestoreState {
  final UserModel userData;
  const FirestoreSuccess(this.userData);

  @override
  List<Object?> get props => [userData];
}

class FirestoreError extends FirestoreState {
  @override
  List<Object?> get props => [];
}
