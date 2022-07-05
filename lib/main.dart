import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flame_firebase/game/tutorial_game.dart';
import 'package:flutter_flame_firebase/widgets/main_menu.dart';
import 'firebase_options.dart';

/// This is the single instance of our TutorialGame which
/// will be reused throughout the lifecycle of the game.
TutorialGame _tutorialGame = TutorialGame();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TutorialGameApp());
}

class TutorialGameApp extends StatelessWidget {
  const TutorialGameApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutorial Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Settings up some default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget(
          // This will display a loading bar until TutorialGame completes
          // its onLoad method.
          loadingBuilder: (conetxt) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          // Register all the overlays that will be used by this game.
          overlayBuilderMap: {
            MainMenu.id: (_, TutorialGame gameRef) => MainMenu(gameRef),
          },
          // By default MainMenu overlay will be active.
          initialActiveOverlays: const [MainMenu.id],
          game: _tutorialGame,
        ),
      ),
    );
  }
}
