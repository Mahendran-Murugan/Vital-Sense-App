import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalsense/routes/constants.dart';
import 'package:vitalsense/utils/show_error_dialog.dart';

const List<String> list = <String>['Patient', 'Doctor'];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;

  String s = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String dropDownValue = list.first;

  readPref() async {
    final pre = await SharedPreferences.getInstance();
    s = pre.getString("status") ?? " ";
  }

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  void setData(String name, String email, String status, User? user) async {
    if (user == null) return;
    DatabaseReference curr = _dbRef.child('users').child(user.uid);
    curr.set({
      "name": name,
      "id": user.uid,
      "email": email,
      "status": status,
    });
    if (status == "Patient") {
      DatabaseReference curr2 = _dbRef.child('patients').child(user.uid);
      curr2.set({
        "name": name,
        "id": user.uid,
        "email": email,
        "status": status,
        "prescription": "No Presciption",
      });
    }
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
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
        title: Text('R E G I S T E R',
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
              controller: _name,
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
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
                final name = _name.text;
                final email = _email.text;
                final pass = _password.text;
                try {
                  await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: pass,
                  );
                  final user = _auth.currentUser;
                  setData(name, email, dropDownValue, user);
                  () => user?.sendEmailVerification();
                  if (!context.mounted) {
                    log("Context Error");
                  } else {
                    Navigator.of(context).pushNamed(
                      verifyEmailRoute,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (!context.mounted) {
                    log("Context Error");
                  } else {
                    if (e.code == 'weak-password') {
                      await showErrorDialog(
                        context,
                        'Weak Password',
                      );
                    } else if (e.code == 'email-already-in-use') {
                      await showErrorDialog(
                        context,
                        'Email Already in Use',
                      );
                    } else if (e.code == 'invalid-email') {
                      await showErrorDialog(
                        context,
                        'Invalid Email',
                      );
                    } else {
                      await showErrorDialog(
                        context,
                        'Error:${e.code}',
                      );
                    }
                  }
                } catch (e) {
                  if (!context.mounted) {
                    log("Context Error");
                  } else {
                    await showErrorDialog(
                      context,
                      'Error:${e.toString()}',
                    );
                  }
                }
              },
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text("Already Registered? Login Here!"),
            ),
          ],
        ),
      ),
    );
  }
}
