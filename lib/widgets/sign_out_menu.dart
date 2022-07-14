import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flame_firebase/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_flame_firebase/game/tutorial_game.dart';

class SignOutMenu extends StatelessWidget {
  static const id = 'SignOutMenu';

  final TutorialGame gameRef;

  const SignOutMenu(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.black.withAlpha(100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    'Tutorial Game',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (gameRef.userDataSubscription != null) {
                        gameRef.userDataSubscription?.cancel();
                        gameRef.firestoreData.text = 'Firebase UserDoc: ???';
                        gameRef.firestoreListenData.text =
                            'Firebase UserDocL: ???';
                      }
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationSignedOut());
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
