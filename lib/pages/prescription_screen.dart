import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalsense/pages/vital_screen.dart';

class PrescriptionScreen extends StatefulWidget {
  final String uid;
  const PrescriptionScreen({super.key, required this.uid});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  late final TextEditingController _prescription;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  void setData(String uid) async {
    DatabaseReference curr = _dbRef.child('patients').child(uid);
    curr.update({
      "prescription": _prescription.text,
    });
  }

  @override
  void initState() {
    _prescription = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('C H A T B O T',
            style: GoogleFonts.amaranth(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _prescription,
              enableSuggestions: false,
              minLines: 1,
              maxLines: 10,
              autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter The Prescription",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => {
                setData(widget.uid),
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VitalScreen(
                      uid: widget.uid,
                    ),
                  ),
                )
              },
              child: const Text(
                "Submit",
              ),
            )
          ],
        ),
      ),
    );
  }
}
