import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flame_firebase/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_flame_firebase/game/tutorial_game.dart';

class SignInMenu extends StatefulWidget {
  static const id = 'SignInMenu';
  final TutorialGame gameRef;

  const SignInMenu(final this.gameRef, {Key? key}) : super(key: key);

  @override
  State<SignInMenu> createState() => _SignInMenuState();
}

class _SignInMenuState extends State<SignInMenu> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String password = '';
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.black.withAlpha(100),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 48),
            child: FittedBox(
              child: IntrinsicWidth(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                  child: Column(
                    children: [
                      const Text(
                        'Login Screen',
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 22.0, color: Color(0xFFbdc6cf)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Email',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _emailController.clear();
                            },
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 22.0, color: Color(0xFFbdc6cf)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _passwordController.clear();
                            },
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // gameRef.overlays.remove(SignInMenu.id);
                          context.read<AuthenticationBloc>().add(
                              AuthenticationRequested(
                                  type: AuthType.signInCredentials,
                                  email: _emailController.text,
                                  password: _passwordController.text));
                        },
                        child: const Text(
                          'Login',
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
        ),
      ),
    );
  }
}
