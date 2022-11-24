import 'dart:async';
import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flame_firebase/features/authentication/authentication_repository_impl.dart';
import 'package:flutter_flame_firebase/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_flame_firebase/features/firestore/bloc/firestore_bloc.dart';
import 'package:flutter_flame_firebase/features/firestore/firestore_repository_impl.dart';
import 'package:flutter_flame_firebase/game/tutorial_game.dart';
import 'package:flutter_flame_firebase/widgets/main_menu.dart';
import 'package:flutter_flame_firebase/widgets/sign_in_menu.dart';
import 'package:flutter_flame_firebase/widgets/sign_out_menu.dart';
import 'app_bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    Bloc.observer = AppBlocObserver();
    runApp(MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => AuthenticationBloc(AuthenticationRepositoryImpl())
          ..add(AuthenticationStarted()),
      ),
      BlocProvider(
        create: (context) => FirestoreBloc(FirestoreRepositoryImpl()),
      )
    ], child: const TutorialGameApp()));
  }, (error, stackTrace) {
    log(error.toString(), stackTrace: stackTrace);
  });
}

class TutorialGameApp extends StatelessWidget {
  const TutorialGameApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutorial Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: const GameGameWidgetWidget(),
    );
  }
}

class GameGameWidgetWidget extends StatelessWidget {
  const GameGameWidgetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();
    final firestoreBloc = context.read<FirestoreBloc>();
    // return SignInView();
    return Scaffold(
      body: GameWidget(
        loadingBuilder: (conetxt) => const Center(
          child: SizedBox(
            width: 200,
            child: LinearProgressIndicator(),
          ),
        ),
        overlayBuilderMap: {
          MainMenu.id: (_, TutorialGame gameRef) => MainMenu(gameRef),
          // SignInView.id: (_, TutorialGame gameRef) => SignInView(gameRef),
          SignInMenu.id: (_, TutorialGame gameRef) => SignInMenu(gameRef),
          SignOutMenu.id: (_, TutorialGame gameRef) => SignOutMenu(gameRef),
        },
        initialActiveOverlays: const [MainMenu.id],
        game: TutorialGame(authBloc: authBloc, firestoreBloc: firestoreBloc),
      ),
    );
  }
}
