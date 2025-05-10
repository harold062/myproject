import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/profileFeatures/medDetails.dart';
import 'package:myproject/screens/profile.dart';

class CurrentMedicationScreen extends StatefulWidget {
  const CurrentMedicationScreen({super.key});

  @override
  State<CurrentMedicationScreen> createState() =>
      _CurrentMedicationScreenState();
}

class _CurrentMedicationScreenState extends State<CurrentMedicationScreen> {
  List<Map<String, dynamic>> medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedications();
  }

  Future<void> _fetchMedications() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists && userDoc['medications'] != null) {
          List<dynamic> fetchedMedications = userDoc['medications'];
          setState(() {
            medications =
                fetchedMedications
                    .map((medication) => Map<String, dynamic>.from(medication))
                    .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching medications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveMedications() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(user.uid)
            .update({'medications': medications});
      }
    } catch (e) {
      print('Error saving medications: $e');
    }
  }

  void _deleteMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
    _saveMedications(); // Save to Firestore
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        flexibleSpace: const FlexibleSpaceBar(
          background: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final medication = medications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.medication,
                        color: Colors.deepPurple,
                      ),
                      title: Text(
                        medication['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Reminder Time: ${medication['time']}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                'Dosage:',
                                '${medication['dosage'] ?? 'N/A'} times per day',
                              ),
                              _buildDetailRow(
                                'Time of Intake:',
                                medication['intakeTime'] ??
                                    medication['time'] ??
                                    'N/A',
                              ),
                              _buildDetailRow(
                                'Total Weeks:',
                                '${medication['totalWeeks'] ?? 'N/A'}',
                              ),
                              _buildDetailRow(
                                'Weeks Left:',
                                '${medication['weeksLeft'] ?? 'N/A'}',
                              ),
                              _buildDetailRow(
                                'Total Tablets:',
                                '${medication['totalTablets'] ?? 'N/A'}',
                              ),
                              _buildDetailRow(
                                'Tablets Left:',
                                '${medication['tabletsLeft'] ?? 'N/A'}',
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MedicationDetailsScreen(
                                          medication: medication,
                                          index: index,
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMedication(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
