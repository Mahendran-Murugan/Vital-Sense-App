import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalsense/routes/constants.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenViewState();
}

class _VerifyEmailScreenViewState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('V E R I F Y   E M A I L',
            style: GoogleFonts.amaranth(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
                'We\'ve send you an email verification. Please verify your email'),
            const Text('Haven\'t receive an email. Cick the Button below'),
            TextButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                log('${user?.emailVerified}');
                user?.sendEmailVerification();
              },
              child: const Text("Resend Email Verification"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) {
                  log("Context Error");
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              },
              child: const Text("Restart"),
            )
          ],
        ),
      ),
    );
  }
}
