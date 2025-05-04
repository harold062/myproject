import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/screens/profile.dart';

class MedicalInfoScreen extends StatefulWidget {
  const MedicalInfoScreen({super.key});

  @override
  State<MedicalInfoScreen> createState() => _MedicalInfoScreenState();
}

class _MedicalInfoScreenState extends State<MedicalInfoScreen> {
  bool isEditMode = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  final TextEditingController surgeryDetailsController =
      TextEditingController();
  final TextEditingController medicationDetailsController =
      TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController none = TextEditingController();
  final TextEditingController otherCauseController = TextEditingController();

  bool hadSurgery = false;
  bool noMedication = false;
  bool noAllergies = false;

  final Map<String, bool> medicalHistory = {
    'Breathing Problems': false,
    'Stroke': false,
    'Depression': false,
    'Pregnant': false,
    'Heart Problems': false,
    'Kidney Problems': false,
    'Diabetes': false,
    'Smoking': false,
    'Headaches': false,
    'Car Accident': false,
    'Work Injury': false,
    'Gradual Onset': false,
    'None': false,
    'Other': false,
  };

  String? otherCause;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicalInfo();
  }

  Future<void> _fetchMedicalInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection(
                  'users',
                ) // Ensure this matches your Firestore structure
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          final medicalInfo = userDoc['medicalInfo'] ?? {};
          setState(() {
            nameController.text = medicalInfo['name'] ?? '';
            dateController.text = medicalInfo['birthday'] ?? '';
            problemController.text = medicalInfo['problem'] ?? '';
            surgeryDetailsController.text = medicalInfo['surgeryDetails'] ?? '';
            medicationDetailsController.text =
                medicalInfo['medicationDetails'] ?? '';
            allergiesController.text = medicalInfo['allergies'] ?? '';
            hadSurgery = medicalInfo['hadSurgery'] ?? false;
            noMedication = medicalInfo['noMedication'] ?? false;
            noAllergies = medicalInfo['noAllergies'] ?? false;

            if (medicalInfo['medicalHistory'] != null) {
              Map<String, dynamic> history = Map<String, dynamic>.from(
                medicalInfo['medicalHistory'],
              );
              history.forEach((key, value) {
                if (medicalHistory.containsKey(key)) {
                  medicalHistory[key] = value;
                }
              });
              // Load OtherCause if it exists
              if (history.containsKey('OtherCause')) {
                otherCause = history['OtherCause'];
              }
            }
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching medical info: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveMedicalInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final Map<String, dynamic> historyToSave = Map.from(medicalHistory);
          if (otherCause != null) {
            historyToSave['OtherCause'] = otherCause;
          }

          // Save the medical information in the "users" collection under the same document
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
                'medicalInfo': {
                  'name': nameController.text,
                  'birthday': dateController.text,
                  'problem': problemController.text,
                  'surgeryDetails': surgeryDetailsController.text,
                  'medicationDetails': medicationDetailsController.text,
                  'allergies': allergiesController.text,
                  'hadSurgery': hadSurgery,
                  'noMedication': noMedication,
                  'noAllergies': noAllergies,
                  'medicalHistory': historyToSave,
                },
              });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medical information saved successfully!'),
            ),
          );

          // Fetch the updated data to ensure it remains consistent
          await _fetchMedicalInfo();

          setState(() {
            isEditMode = false; // Exit edit mode after saving
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save medical information: $e')),
        );
      }
    }
  }

  void _showOtherCauseDialog() {
    final TextEditingController otherCauseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Specify Other Cause'),
          content: TextField(
            controller: otherCauseController,
            decoration: const InputDecoration(
              labelText: 'Enter cause',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  otherCause = otherCauseController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget buildSection(String title, IconData icon, List<Widget> content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Information Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditMode ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (isEditMode) {
                _saveMedicalInfo(); // Save data and reload it
              } else {
                setState(() {
                  isEditMode = true; // Enter edit mode
                });
              }
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      buildSection('Personal Information', Icons.person, [
                        ListTile(
                          leading: const Icon(
                            Icons.badge,
                            color: Colors.deepPurple,
                          ),
                          title:
                              isEditMode
                                  ? TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  )
                                  : Text('Name: ${nameController.text}'),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.deepPurple,
                          ),
                          title:
                              isEditMode
                                  ? TextFormField(
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                    ),
                                  )
                                  : Text('Date: ${dateController.text}'),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.description,
                            color: Colors.deepPurple,
                          ),
                          title:
                              isEditMode
                                  ? TextFormField(
                                    controller: problemController,
                                    decoration: const InputDecoration(
                                      labelText: 'Describe Problem',
                                    ),
                                  )
                                  : Text(
                                    'Describe Problem: ${problemController.text}',
                                  ),
                        ),
                      ]),
                      buildSection('Cause of Current Problem', Icons.warning, [
                        ...[
                          'Car Accident',
                          'Work Injury',
                          'Gradual Onset',
                          'None',
                          'Other',
                        ].map((cause) {
                          return CheckboxListTile(
                            title: Text(
                              cause == 'Other' && otherCause != null
                                  ? 'Other: $otherCause'
                                  : cause,
                            ),
                            value: medicalHistory[cause] ?? false,
                            onChanged:
                                isEditMode
                                    ? (value) {
                                      setState(() {
                                        medicalHistory[cause] = value!;
                                      });
                                      if (cause == 'Other' && value == true) {
                                        _showOtherCauseDialog();
                                      } else if (cause == 'Other' &&
                                          value == false) {
                                        otherCause = null;
                                      }
                                    }
                                    : null,
                          );
                        }).toList(),
                      ]),
                      buildSection('Past Medical History', Icons.history, [
                        ...medicalHistory.keys
                            .where(
                              (key) =>
                                  ![
                                    'Car Accident',
                                    'Work Injury',
                                    'Gradual Onset',
                                    'None',
                                    'Other',
                                  ].contains(key),
                            )
                            .map((key) {
                              return CheckboxListTile(
                                title: Text(key),
                                value: medicalHistory[key],
                                onChanged:
                                    isEditMode
                                        ? (value) {
                                          setState(() {
                                            medicalHistory[key] = value!;
                                          });
                                        }
                                        : null,
                              );
                            })
                            .toList(),
                        ListTile(
                          leading: const Icon(
                            Icons.local_hospital,
                            color: Colors.deepPurple,
                          ),
                          title:
                              isEditMode
                                  ? TextFormField(
                                    controller: surgeryDetailsController,
                                    decoration: const InputDecoration(
                                      labelText: 'Surgeries / Hospitalizations',
                                    ),
                                  )
                                  : Text(
                                    'Surgeries / Hospitalizations: ${surgeryDetailsController.text.isEmpty ? "None" : surgeryDetailsController.text}',
                                  ),
                        ),
                      ]),
                      buildSection('Medications', Icons.medication, [
                        CheckboxListTile(
                          title: const Text('No Medication'),
                          value: noMedication,
                          onChanged:
                              isEditMode
                                  ? (value) {
                                    setState(() {
                                      noMedication = value!;
                                    });
                                  }
                                  : null,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.medical_services,
                            color: Colors.deepPurple,
                          ),
                          title:
                              isEditMode
                                  ? TextFormField(
                                    controller: medicationDetailsController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Medications (Name, Dose, Reason)',
                                    ),
                                  )
                                  : Text(
                                    'Medications: ${medicationDetailsController.text.isEmpty ? "None" : medicationDetailsController.text}',
                                  ),
                        ),
                      ]),
                      buildSection('Allergies', Icons.warning_amber, [
                        CheckboxListTile(
                          title: const Text('No Known Allergies'),
                          value: noAllergies,
                          onChanged:
                              isEditMode
                                  ? (value) {
                                    setState(() {
                                      noAllergies = value!;
                                    });
                                  }
                                  : null,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.warning_amber,
                            color: Colors.deepPurple,
                          ),
                          title:
                              isEditMode
                                  ? TextFormField(
                                    controller: allergiesController,
                                    decoration: const InputDecoration(
                                      labelText: 'Allergies',
                                    ),
                                  )
                                  : Text(
                                    'Allergies: ${allergiesController.text.isEmpty ? "None" : allergiesController.text}',
                                  ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
    );
  }
}
