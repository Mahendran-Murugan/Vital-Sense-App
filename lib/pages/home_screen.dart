import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitalsense/firebase_options.dart';
import 'package:vitalsense/pages/chat_screen.dart';
import 'package:vitalsense/pages/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (_auth.currentUser != null) {
              return const ChatScreen();
            } else {
              return const LoginScreen();
            }
          default:
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
