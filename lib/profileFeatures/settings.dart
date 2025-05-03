import 'package:flutter/material.dart';
import 'package:myproject/screens/profile.dart';
import 'package:myproject/settingFeatures/changePassword.dart';
import 'package:myproject/settingFeatures/emergencyContact.dart';
import 'package:myproject/settingFeatures/helpSupport.dart';
import 'package:myproject/settingFeatures/language.dart';
import 'package:myproject/settingFeatures/privacyPolicy.dart';
import 'package:myproject/settingFeatures/profileEdit.dart';
import 'package:myproject/settingFeatures/remindersAlert.dart';

Widget buildSettingsTile({
  required IconData icon,
  required String title,
  String? subtitle,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    ),
  );
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Profile Section
          const ListTile(
            title: Text(
              'Profile Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ),
          buildSettingsTile(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()),
              );
            },
          ),
          buildSettingsTile(
            icon: Icons.contacts,
            title: 'Emergency Contacts',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => EmergencyContactsScreen()),
              );
            },
          ),

          // Notifications
          const ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          buildSettingsTile(
            icon: Icons.notifications,
            title: 'Reminders & Alerts',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RemindersAndAlertsScreen(),
                ),
              );
            },
          ),

          // Data & Security
          const ListTile(
            title: Text(
              'Privacy & Security',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          buildSettingsTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
              );
            },
          ),

          // Language & Accessibility
          const ListTile(
            title: Text(
              'General',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSettingsScreen(),
                ),
              );
            },
          ),

          // Support & Legal
          const ListTile(
            title: Text(
              'Support',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HelpAndSupportScreen()),
              );
            },
          ),
          buildSettingsTile(
            icon: Icons.policy,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
              );
            },
          ),
          buildSettingsTile(
            icon: Icons.info,
            title: 'App Version',
            subtitle: 'v1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
