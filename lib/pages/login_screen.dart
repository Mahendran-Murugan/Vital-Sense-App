import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalsense/routes/constants.dart';
import 'package:vitalsense/utils/show_error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>['Patient', 'Doctor'];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String s = "";

  String dropDownValue = list.first;

  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("users");

  void selectiveRendering(User? user) async {
    if (user == null) return;
    final ref = await _dbRef.child(user.uid).child("status").get();
    final pre = await SharedPreferences.getInstance();
    if (ref.exists) {
      await pre.setString("status", ref.value as String);
    }
  }

  readPref() async {
    final pre = await SharedPreferences.getInstance();
    s = pre.getString("status") ?? " ";
    print(s);
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('Login',
            style: GoogleFonts.amaranth(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    'Status :',
                    style: GoogleFonts.amaranth(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: DropdownMenu<String>(
                    initialSelection: list.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    },
                    dropdownMenuEntries:
                        list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _email,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your password",
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final pass = _password.text;
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: pass,
                  );
                  if (!context.mounted) {
                    log("Context Error");
                  } else {
                    final user = FirebaseAuth.instance.currentUser;
                    selectiveRendering(user);
                    await readPref();
                    if (user?.emailVerified ?? false) {
                      if (dropDownValue == "Patient") {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          patientRoute,
                          (route) => false,
                        );
                      } else if (dropDownValue == "Doctor") {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          doctorRoute,
                          (route) => false,
                        );
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          chatRoute,
                          (route) => false,
                        );
                      }
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) {
                    log("Context Error");
                  } else {
                    if (e.code == 'invalid-credential') {
                      await showErrorDialog(
                        context,
                        "Invalid Credentials",
                      );
                    } else {
                      await showErrorDialog(
                        context,
                        "Error: ${e.code}",
                      );
                    }
                  }
                } catch (e) {
                  if (!context.mounted) {
                    log("Context Error");
                  } else {
                    await showErrorDialog(
                      context,
                      "Error: ${e.toString()}",
                    );
                  }
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Not Registered? Reister here!"),
            ),
          ],
        ),
      ),
    );
  }
}
