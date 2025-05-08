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
                .collection('users')
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

          await _fetchMedicalInfo();

          setState(() {
            isEditMode = false;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 0,
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        children: content,
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditMode,
    String? displayText,
    String? hintText,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title:
          isEditMode
              ? TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hintText,
                ),
              )
              : Text(
                '$label: ${controller.text.isEmpty ? displayText ?? "None" : controller.text}',
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Information Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'PlusJakartSans',
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              color: Colors.black,
            ),
            onPressed: () {
              if (isEditMode) {
                _saveMedicalInfo();
              } else {
                setState(() {
                  isEditMode = true;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade100.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        buildSection('Personal Information', Icons.person, [
                          buildListTile(
                            icon: Icons.badge,
                            label: 'Name',
                            controller: nameController,
                            isEditMode: isEditMode,
                          ),
                          buildListTile(
                            icon: Icons.calendar_today,
                            label: 'Date',
                            controller: dateController,
                            isEditMode: isEditMode,
                          ),
                          buildListTile(
                            icon: Icons.description,
                            label: 'Describe Problem',
                            controller: problemController,
                            isEditMode: isEditMode,
                          ),
                        ]),
                        buildSection(
                          'Cause of Current Problem',
                          Icons.warning,
                          [
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
                                          if (cause == 'Other' &&
                                              value == true) {
                                            _showOtherCauseDialog();
                                          } else if (cause == 'Other' &&
                                              value == false) {
                                            otherCause = null;
                                          }
                                        }
                                        : null,
                              );
                            }).toList(),
                          ],
                        ),
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
                          buildListTile(
                            icon: Icons.local_hospital,
                            label: 'Surgeries / Hospitalizations',
                            controller: surgeryDetailsController,
                            isEditMode: isEditMode,
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
                          buildListTile(
                            icon: Icons.medical_services,
                            label: 'Medications (Name, Dose, Reason)',
                            controller: medicationDetailsController,
                            isEditMode: isEditMode,
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
                          buildListTile(
                            icon: Icons.warning_amber,
                            label: 'Allergies',
                            controller: allergiesController,
                            isEditMode: isEditMode,
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
