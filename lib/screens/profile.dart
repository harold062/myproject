import 'package:flutter/material.dart';
import 'package:myproject/screens/login.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/logo.png',
                        ), // Make sure the asset path is correct
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
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu Items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMenuItem(
                    Icons.medical_information,
                    'Medical Information',
                  ),
                  _buildMenuItem(Icons.health_and_safety, 'Medical Conditions'),
                  _buildMenuItem(Icons.calendar_today, 'Date of Birth'),
                  _buildMenuItem(Icons.medication, 'Current Medication'),
                  _buildMenuItem(Icons.wifi, 'Connect To IOT Devices'),
                  _buildMenuItem(Icons.settings, 'Settings'),
                  _buildMenuItem(
                    Icons.logout,
                    'Logout',
                    isLogout: true,
                  ), // moved before Spacer
                  const Spacer(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label, {
    String? badge,
    bool isLogout = false,
  }) {
    return ElevatedButton(
      onPressed: () {
        if (isLogout) {
        } else {}
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isLogout ? Colors.red : Colors.black),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'PlusJakartaSans',
              color: isLogout ? Colors.red : Colors.black,
            ),
          ),
          const Spacer(),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8E2DE2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
