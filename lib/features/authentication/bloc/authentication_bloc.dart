import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flame_firebase/features/authentication/authentication_repository_impl.dart';
import 'package:flutter_flame_firebase/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationUnknown()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        try {
          UserModel user =
              await _authenticationRepository.getCurrentUser().first;
          if (user.uid != "uid") {
            String? displayName =
                await _authenticationRepository.retrieveUserName(user);
            emit(
                AuthenticationSuccess(uid: user.uid, displayName: displayName));
          } else {
            emit(const AuthenticationNotLoggedIn());
          }
        } catch (e) {
          emit(AuthenticationNotLoggedIn(errorMessage: e.toString()));
        }
      } else if (event is AuthenticationSignedOut) {
        await _authenticationRepository.signOut();
        emit(const AuthenticationNotLoggedIn());
      }
    });
    on<AuthenticationRequested>(_onSignInRequested);
    on<AuthenticationSignedOut>(_onSignOutRequested);
  }
  _onSignInRequested(
      AuthenticationRequested event, Emitter<AuthenticationState> emit) async {
    try {
      if (event.type == AuthType.signInAnonymously) {
        await _authenticationRepository.signInAnonymously();
      } else if (event.type == AuthType.signInCredentials) {
        UserModel user =
            UserModel(uid: 'uid', email: event.email, password: event.password);
        UserCredential? creds = await _authenticationRepository.signIn(user);
        if (creds != null && creds.user != null) {
          emit(AuthenticationSuccess(
              uid: creds.user!.uid,
              displayName: creds.user?.displayName ?? "No name"));
        }
      } else if (event.type == AuthType.signUpCredentials) {
        UserModel user =
            UserModel(uid: 'uid', email: event.email, password: event.password);
        await _authenticationRepository.signUp(user);
      }
    } catch (e) {
      print(e);
      emit(AuthenticationNotLoggedIn(errorMessage: e.toString()));
    }
  }

  _onSignOutRequested(
      AuthenticationSignedOut event, Emitter<AuthenticationState> emit) async {
    await _authenticationRepository.signOut();
  }
}
