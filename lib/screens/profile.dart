import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/currentMed.dart';
import 'package:myproject/profileFeatures/medicalCond.dart';
import 'package:myproject/profileFeatures/medicalInfo.dart';
import 'package:myproject/profileFeatures/settings.dart';
import 'package:myproject/screens/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildMenuCard({
      required IconData icon,
      required String label,
      required String recordsFound,
      VoidCallback? onTap,
    }) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF8E2DE2),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recordsFound,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.black54),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Top Profile Section with Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // Placeholder for alignment
                    ],
                  ),
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Harold Selfides',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'ClashDisplay',
                    ),
                  ),
                  const Text(
                    'Patient',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'ClashDisplay',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  buildMenuCard(
                    icon: Icons.medical_information,
                    label: 'Medical Information',
                    recordsFound: '4 records found',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicalInfoScreen(),
                        ),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.health_and_safety,
                    label: 'Medical Conditions',
                    recordsFound: '3 records found',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicalConditionsScreen(),
                        ),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.calendar_today,
                    label: 'Date of Birth',
                    recordsFound: '1 record found',
                    onTap: () {},
                  ),
                  buildMenuCard(
                    icon: Icons.medication,
                    label: 'Current Medication',
                    recordsFound: '2 records found',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CurrentMedicationScreen(),
                        ),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.wifi,
                    label: 'Connect To IOT Devices',
                    recordsFound: 'No records found',
                    onTap: () {},
                  ),
                  buildMenuCard(
                    icon: Icons.settings,
                    label: 'Settings',
                    recordsFound: '1 record found',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Settings()),
                      );
                    },
                  ),
                  buildMenuCard(
                    icon: Icons.logout,
                    label: 'Logout',
                    recordsFound: '',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LogInPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
