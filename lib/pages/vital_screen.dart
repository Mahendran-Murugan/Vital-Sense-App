import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalsense/pages/prescription_screen.dart';

class VitalScreen extends StatefulWidget {
  final String uid;
  const VitalScreen({super.key, required this.uid});

  @override
  State<VitalScreen> createState() => _VitalScreenState();
}

class _VitalScreenState extends State<VitalScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  int temp = 0, pulse = 0, humidity = 0, roomtemp = 0, air = 0;

  @override
  Widget build(BuildContext context) {
    _dbRef.child("temp").onValue.listen(
      (event) {
        setState(() {
          temp = event.snapshot.value as int;
        });
      },
    );

    _dbRef.child("pulse").onValue.listen(
      (event) {
        setState(() {
          pulse = event.snapshot.value as int;
        });
      },
    );

    _dbRef.child("humidity").onValue.listen(
      (event) {
        setState(() {
          humidity = event.snapshot.value as int;
        });
      },
    );

    _dbRef.child("roomtemp").onValue.listen(
      (event) {
        setState(() {
          roomtemp = event.snapshot.value as int;
        });
      },
    );

    _dbRef.child("air").onValue.listen(
      (event) {
        setState(() {
          air = event.snapshot.value as int;
        });
      },
    );

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
            Row(
              children: [
                const Text(
                  "Temperature:",
                ),
                Text(
                  "$temp",
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Pulse:",
                ),
                Text(
                  "$pulse",
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Humidity:",
                ),
                Text(
                  "$humidity",
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Room Temperature:",
                ),
                Text(
                  "$roomtemp",
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Air Quality:",
                ),
                Text(
                  "$air",
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PrescriptionScreen(
                    uid: widget.uid,
                  ),
                ))
              },
              child: const Text(
                "Prescribe Medicine",
              ),
            )
          ],
        ),
      ),
    );
  }
}
