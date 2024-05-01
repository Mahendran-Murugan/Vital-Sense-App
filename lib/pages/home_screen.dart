import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vitalsense/firebase_options.dart';
import 'package:vitalsense/pages/chat_screen.dart';
import 'package:vitalsense/pages/doctor_screen.dart';
import 'package:vitalsense/pages/login_screen.dart';
import 'package:vitalsense/pages/patient_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String status = "Patient";

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("users");

  Future<String> selectiveRendering(User? user) async {
    if (user == null) return "";
    final ref = await _dbRef.child(user.uid).child("status").get();
    if (ref.exists) {
      status = ref.value as String;
      print(status);
      return status;
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    selectiveRendering(_auth.currentUser);
    setStatus();
  }

  void setStatus() {
    setState(() {
      status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        User? user = _auth.currentUser;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (user != null) {
              if (status == "Patient") {
                return const PatientScreen();
              } else if (status == "Doctor") {
                return const DoctorScreen();
              } else {
                return const ChatScreen();
              }
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
