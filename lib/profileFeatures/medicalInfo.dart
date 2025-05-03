import 'package:flutter/material.dart';
import 'package:myproject/screens/profile.dart';

class MedicalInfoScreen extends StatefulWidget {
  const MedicalInfoScreen({super.key});

  @override
  State<MedicalInfoScreen> createState() => _MedicalInfoScreenState();
}

class _MedicalInfoScreenState extends State<MedicalInfoScreen> {
  bool isEditMode = false;

  // Controllers for editable fields
  final TextEditingController nameController = TextEditingController(
    text: 'Harold Selfides',
  );
  final TextEditingController dateController = TextEditingController(
    text: '2023-05-12',
  );
  final TextEditingController problemController = TextEditingController(
    text: 'Headache',
  );
  final TextEditingController surgeryDetailsController =
      TextEditingController();
  final TextEditingController medicationDetailsController =
      TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  // Checkboxes
  bool hadSurgery = false;
  bool noMedication = false;
  bool noAllergies = false;

  // Checkbox options for medical history
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
  };

  Widget buildSection(String title, IconData icon, List<Widget> content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
              setState(() {
                isEditMode = !isEditMode;
              });
              if (!isEditMode) {
                // Save logic can be added here (e.g., send data to a server)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved successfully!')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSection('Personal Information', Icons.person, [
              ListTile(
                leading: const Icon(Icons.badge, color: Colors.deepPurple),
                title:
                    isEditMode
                        ? TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
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
                          decoration: const InputDecoration(labelText: 'Date'),
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
                        : Text('Describe Problem: ${problemController.text}'),
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
                  title: Text(cause),
                  value: medicalHistory[cause] ?? false,
                  onChanged:
                      isEditMode
                          ? (value) {
                            setState(() {
                              medicalHistory[cause] = value!;
                            });
                          }
                          : null,
                );
              }).toList(),
            ]),
            buildSection('Past Medical History', Icons.history, [
              ...medicalHistory.keys.map((key) {
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
              }).toList(),
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
                            labelText: 'Medications (Name, Dose, Reason)',
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
    );
  }
}
