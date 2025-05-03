import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/settings.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Subtle background color
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Privacy Policy Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We value your privacy. This policy explains how we collect, use, and protect your personal data.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            _buildSection(
              icon: Icons.data_usage,
              title: '1. Data Collection',
              content:
                  'We collect personal information such as name, email, and phone number when you register. We may also collect usage data, such as your interactions with the app.',
            ),
            _buildSection(
              icon: Icons.settings,
              title: '2. Data Usage',
              content:
                  'We use your data to provide and improve the service, communicate with you, and send notifications related to your account.',
            ),
            _buildSection(
              icon: Icons.lock,
              title: '3. Data Protection',
              content:
                  'We take appropriate measures to safeguard your personal data, including encryption and secure access protocols.',
            ),
            _buildSection(
              icon: Icons.share,
              title: '4. Third-Party Services',
              content:
                  'We may share your data with trusted third-party services to perform specific functions, such as email notifications or payment processing.',
            ),
            _buildSection(
              icon: Icons.verified_user,
              title: '5. User Rights',
              content:
                  'You have the right to access, correct, or delete your personal data. You can contact us for any data-related requests.',
            ),
            _buildSection(
              icon: Icons.contact_mail,
              title: '6. Contact Us',
              content:
                  'If you have any questions or concerns about our privacy policy, please contact us at privacy@example.com.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
