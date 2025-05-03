import 'package:flutter/material.dart';
import 'package:myproject/screens/profile.dart';

class MedicalInfoScreen extends StatelessWidget {
  const MedicalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildSection(String title, List<Widget> content) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: ExpansionTile(
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medical Information',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSection('1. Personal Information', [
              const ListTile(title: Text('Full Name: Harold Selfides')),
              const ListTile(
                title: Text('Age / Date of Birth: 45 / 1978-05-12'),
              ),
              const ListTile(title: Text('Sex / Gender: Male')),
              const ListTile(title: Text('Contact Information: +1234567890')),
              const ListTile(
                title: Text('Emergency Contact(s): Mom - +0987654321'),
              ),
              const ListTile(
                title: Text('Address: 123 Main Street, City, Country'),
              ),
            ]),
            buildSection('2. Medical History', [
              const ListTile(
                title: Text('Chronic Conditions: Diabetes, Hypertension'),
              ),
              const ListTile(
                title: Text('Past Surgeries: Appendectomy (2010)'),
              ),
              const ListTile(title: Text('Allergies: Penicillin, Peanuts')),
              const ListTile(
                title: Text('Vaccination Record: Fully Vaccinated'),
              ),
              const ListTile(
                title: Text('Previous Illnesses: Pneumonia (2015)'),
              ),
            ]),
            buildSection('3. Medications', [
              const ListTile(
                title: Text('Current Medications: Aspirin (100mg, daily)'),
              ),
              const ListTile(
                title: Text('Past Medications: Metformin (2015-2020)'),
              ),
              const ListTile(title: Text('Supplements: Vitamin D, Omega-3')),
            ]),
            buildSection('4. Clinical Information', [
              const ListTile(title: Text('Blood Pressure: 120/80 mmHg')),
              const ListTile(title: Text('Heart Rate: 72 bpm')),
              const ListTile(title: Text('Temperature: 98.6°F')),
              const ListTile(title: Text('Oxygen Saturation: 98%')),
              const ListTile(
                title: Text('Lab Test Results: Normal CBC, High Cholesterol'),
              ),
              const ListTile(
                title: Text('Imaging Results: Normal X-ray (2023)'),
              ),
            ]),
            buildSection('5. Physician & Care Info', [
              const ListTile(
                title: Text('Primary Care Physician: Dr. John Doe'),
              ),
              const ListTile(
                title: Text('Specialist(s): Cardiologist - Dr. Jane Smith'),
              ),
              const ListTile(title: Text('Clinic: City Health Clinic')),
              const ListTile(title: Text('Last Visit: 2023-04-01')),
              const ListTile(title: Text('Next Appointment: 2023-10-15')),
            ]),
            buildSection('6. Lifestyle & Social History', [
              const ListTile(title: Text('Smoking: No')),
              const ListTile(title: Text('Alcohol: Occasionally')),
              const ListTile(title: Text('Diet: Balanced')),
              const ListTile(title: Text('Exercise: 3 times a week')),
              const ListTile(title: Text('Sleep Patterns: 7 hours per night')),
              const ListTile(
                title: Text('Living Situation: Lives with family'),
              ),
              const ListTile(title: Text('Occupation: Retired')),
            ]),
            buildSection('7. Mental & Cognitive Health', [
              const ListTile(title: Text('Diagnoses: Anxiety, Depression')),
              const ListTile(title: Text('Cognitive Assessments: Normal')),
              const ListTile(title: Text('Mood Notes: Stable')),
            ]),
            buildSection('8. Emergency Info', [
              const ListTile(title: Text('DNR Status: No')),
              const ListTile(
                title: Text('Medical Conditions to Watch For: Diabetes'),
              ),
              const ListTile(title: Text('Allergic Reactions: Penicillin')),
              const ListTile(
                title: Text('Preferred Hospital: City General Hospital'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
