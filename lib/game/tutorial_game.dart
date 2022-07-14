import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_firebase/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_flame_firebase/features/firestore/bloc/firestore_bloc.dart';
import 'package:flutter_flame_firebase/models/user_model.dart';
import 'package:flutter_flame_firebase/widgets/main_menu.dart';
import 'package:flutter_flame_firebase/widgets/sign_in_menu.dart';
import 'package:flutter_flame_firebase/widgets/sign_out_menu.dart';

class TutorialGame extends FlameGame with HasKeyboardHandlerComponents {
  TutorialGame({required this.authBloc, required this.firestoreBloc});

  final AuthenticationBloc authBloc;
  final FirestoreBloc firestoreBloc;
  String playerState = '???';
  TextComponent authStatus = TextComponent(text: '');
  TextComponent firestoreData =
      TextComponent(text: 'Firebase UserDoc: ???', position: Vector2(0, 30));
  TextComponent firestoreListenData =
      TextComponent(text: 'Firebase UserDocL: ???', position: Vector2(0, 40));

  Stream<UserModel>? userDataStream;
  StreamSubscription<UserModel>? userDataSubscription;
  @override
  Future<void> onLoad() async {
    await addAll([authStatus, firestoreData, firestoreListenData]);
    _updatePlayerState(authBloc.state);
    _updateFirestoreData(firestoreBloc.state);

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<AuthenticationBloc, AuthenticationState>.value(
        value: authBloc,
      ),
      FlameBlocProvider<FirestoreBloc, FirestoreState>.value(
        value: firestoreBloc,
      ),
    ], children: [
      FlameBlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: authBloc,
        onNewState: (state) {
          _updatePlayerState(state);
        },
      ),
      FlameBlocListener<FirestoreBloc, FirestoreState>(
        bloc: firestoreBloc,
        onNewState: (state) {
          _updateFirestoreData(state);
        },
      ),
    ]));
    super.onLoad();
  }

  @override
  void update(double dt) async {
    firestoreData.position = Vector2(0, 20);
    super.update(dt);
  }

  _updateFirestoreData(FirestoreState state) {
    String firestoreState;
    if (state is FirestoreInitial) {
      firestoreState = 'Initial';
    } else if (state is FirestoreError) {
      firestoreState = 'Error';
    } else if (state is FirestoreSuccess) {
      firestoreState = state.userData.displayName ?? 'No display name';
    } else {
      firestoreState = '???';
    }
    firestoreData.text = 'Firebase UserDoc : $firestoreState';
  }

  _updatePlayerState(AuthenticationState state) {
    String playerState;
    if (state is AuthenticationUnknown) {
      playerState = 'Unknown';
    } else if (state is AuthenticationNotLoggedIn) {
      playerState = 'Not Logged In';
      overlays.remove(SignOutMenu.id);
      overlays.add(MainMenu.id);
    } else if (state is AuthenticationSuccess) {
      playerState = 'Logged In. Username: ${state.uid}';
      overlays.remove(SignInMenu.id);
      overlays.add(SignOutMenu.id);
      firestoreBloc.add(FirestoreFetchUserDoc(state.uid));

      if (userDataStream == null) {
        userDataStream = firestoreBloc.listenUserData(state.uid);
        userDataSubscription = userDataStream?.listen((event) {
          firestoreListenData.text = 'Firebase UserDocL : ${event.displayName}';
        });
      }
    } else {
      playerState = '???';
    }
    authStatus.text = 'Firebase Auth Status: $playerState';
  }
}
