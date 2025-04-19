import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myproject/colors.dart';
import 'package:myproject/screens/login.dart';

class MyHomePage extends StatefulWidget {
  final String
  userName; // Assuming userName might relate to a patient eventually

  const MyHomePage({super.key, required this.userName});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseReference _patientsRef;
  String age = "Loading...";
  String height = "N/A"; // Not present in the patients node
  String weight = "N/A"; // Not present in the patients node
  String bloodType = "N/A"; // Not present in the patients node
  int steps = 0; // Need to determine where this comes from
  int calories = 0; // Need to determine where this comes from
  String patientName = "Loading...";

  @override
  void initState() {
    super.initState();
    _patientsRef = FirebaseDatabase.instance.ref().child('patients');
    _patientsRef.child(widget.userName).onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.exists) {
        setState(() {
          age = snapshot.child('age').value?.toString() ?? "N/A";
          patientName = snapshot.child('name').value?.toString() ?? "N/A";
          height = snapshot.child('height').value?.toString() ?? "N/A";
          weight = snapshot.child('weight').value?.toString() ?? "N/A";
          bloodType = snapshot.child('bloodType').value?.toString() ?? "N/A";
        });
        // You would also need to fetch steps and calories, possibly from the 'devices' node
        // based on the 'assignedDeviceID'. This would involve another database query.
        _fetchDeviceData(snapshot.child('assignedDeviceID').value?.toString());
      } else {
        setState(() {
          age = "N/A";
          patientName = "User not found as patient";
        });
      }
    });
  }

  Future<void> _fetchDeviceData(String? deviceID) async {
    if (deviceID != null) {
      DatabaseReference _devicesRef = FirebaseDatabase.instance
          .ref()
          .child('devices')
          .child(deviceID);
      _devicesRef.onValue.listen((event) {
        var snapshot = event.snapshot;
        if (snapshot.exists) {
          // Assuming 'steps' and 'calories' might be under the device node
          setState(() {
            steps = (snapshot.child('steps').value as num?)?.toInt() ?? 0;
            calories = (snapshot.child('calories').value as num?)?.toInt() ?? 0;
            // You might need to adjust the field names based on your actual data
          });
        } else {
          setState(() {
            steps = 0;
            calories = 0;
          });
        }
      });
    } else {
      setState(() {
        steps = 0;
        calories = 0;
      });
    }
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LogInPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("B0E0E6"),
              hexStringToColor("7B68EE"),
              hexStringToColor("005A9C"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back_ios, color: Colors.white),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/profile.jpg",
                        ),
                        radius: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  "Hello $patientName, you are looking fit",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      InfoTile(label: "Age", value: age, unit: "Years"),
                      InfoTile(label: "Height", value: height, unit: "cm"),
                      InfoTile(label: "Weight", value: weight, unit: "kg"),
                      InfoTile(label: "Blood", value: bloodType, unit: "+ve"),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: const Text("Daily Target"),
                      backgroundColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.black87),
                    ),
                    const Text(
                      "Achieved",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Steps", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: steps / 10000,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
                const SizedBox(height: 5),
                Text("$steps", style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 20),
                const Text("Calories", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: calories / 10000,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
                const SizedBox(height: 5),
                Text(
                  "$calories",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for each tile
class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }
}
