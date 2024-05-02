import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitalsense/firebase_options.dart';
import 'package:vitalsense/pages/chat_screen.dart';
import 'package:vitalsense/pages/doctor_screen.dart';
import 'package:vitalsense/pages/login_screen.dart';
import 'package:vitalsense/pages/patient_screen.dart';
import 'package:vitalsense/pages/register_screen.dart';
import 'package:vitalsense/pages/verify_email_screen.dart';
import 'package:vitalsense/routes/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Sense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => const LoginScreen(),
        loginRoute: (context) => const LoginScreen(),
        chatRoute: (context) => const ChatScreen(),
        verifyEmailRoute: (context) => const VerifyEmailScreen(),
        registerRoute: (context) => const RegisterScreen(),
        doctorRoute: (context) => const DoctorScreen(),
        patientRoute: (context) => const PatientScreen(),
      },
    );
  }
}
