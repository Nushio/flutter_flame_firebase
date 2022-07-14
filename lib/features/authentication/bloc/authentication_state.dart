part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationUnknown extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final String uid;
  final String? displayName;
  const AuthenticationSuccess({required this.uid, this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class AuthenticationNotLoggedIn extends AuthenticationState {
  final String? errorMessage;

  const AuthenticationNotLoggedIn({this.errorMessage});
  @override
  List<Object?> get props => [];
}
