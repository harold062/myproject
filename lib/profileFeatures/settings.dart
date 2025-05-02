import 'package:flutter/material.dart';
import 'package:myproject/screens/profile.dart';
import 'package:myproject/settingFeatures/changePassword.dart';
import 'package:myproject/settingFeatures/emergencyContact.dart';
import 'package:myproject/settingFeatures/helpSupport.dart';
import 'package:myproject/settingFeatures/language.dart';
import 'package:myproject/settingFeatures/privacyPolicy.dart';
import 'package:myproject/settingFeatures/profileEdit.dart';
import 'package:myproject/settingFeatures/remindersAlert.dart';

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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Emergency Contacts'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EmergencyContactsScreen(),
                ),
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
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Reminders & Alerts'),
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
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
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
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
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
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpAndSupportScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Version'),
            subtitle: const Text('v1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
