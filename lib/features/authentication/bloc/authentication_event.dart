part of 'authentication_bloc.dart';

enum AuthType { signInAnonymously, signInCredentials, signUpCredentials }

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationRequested extends AuthenticationEvent {
  final AuthType type;
  final String? email;
  final String? password;
  const AuthenticationRequested(
      {required this.type, this.email, this.password});

  @override
  List<Object> get props => [type];
}

class AuthenticationSignedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
