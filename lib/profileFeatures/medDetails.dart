import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/profileFeatures/currentMed.dart';

class MedicationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> medication;
  final int index; // Index of the medication in the list

  const MedicationDetailsScreen({
    super.key,
    required this.medication,
    required this.index,
  });

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState extends State<MedicationDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController timeController;
  late TextEditingController dosageController;
  late TextEditingController totalWeeksController;
  late TextEditingController weeksLeftController;
  late TextEditingController totalTabletsController;
  late TextEditingController tabletsLeftController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current medication data
    nameController = TextEditingController(text: widget.medication['name']);
    timeController = TextEditingController(text: widget.medication['time']);
    dosageController = TextEditingController(
      text: widget.medication['dosage'].toString(),
    );
    totalWeeksController = TextEditingController(
      text: widget.medication['totalWeeks'].toString(),
    );
    weeksLeftController = TextEditingController(
      text: widget.medication['weeksLeft'].toString(),
    );
    totalTabletsController = TextEditingController(
      text: widget.medication['totalTablets'].toString(),
    );
    tabletsLeftController = TextEditingController(
      text: widget.medication['tabletsLeft'].toString(),
    );
  }

  Future<void> _saveChanges() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the current medications list from Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists && userDoc['medications'] != null) {
          List<dynamic> medications = userDoc['medications'];

          // Update the specific medication in the list
          medications[widget.index] = {
            'name': nameController.text,
            'time': timeController.text,
            'dosage': int.parse(dosageController.text),
            'totalWeeks': int.parse(totalWeeksController.text),
            'weeksLeft': int.parse(weeksLeftController.text),
            'totalTablets': int.parse(totalTabletsController.text),
            'tabletsLeft': int.parse(tabletsLeftController.text),
          };

          // Save the updated list back to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'medications': medications});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Medication details updated!')),
          );

          Navigator.pop(context); // Close the details screen
        }
      }
    } catch (e) {
      print('Error saving medication details: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save changes: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameController.text),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Center(
              child: Icon(
                Icons.medication,
                size: 100,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Reminder Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dosageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Dosage (times per day)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: totalWeeksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Weeks',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weeksLeftController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weeks Left',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: totalTabletsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Tablets',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: tabletsLeftController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tablets Left',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveChanges();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurrentMedicationScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
