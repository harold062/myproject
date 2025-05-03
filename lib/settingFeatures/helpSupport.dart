import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/settings.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help and Support',
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
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.blueAccent),
              title: Text('Email: support@example.com'),
            ),
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.blueAccent),
              title: Text('Phone: +1234567890'),
            ),
            const ListTile(
              leading: Icon(Icons.web, color: Colors.blueAccent),
              title: Text('Website: www.example.com'),
            ),
            const SizedBox(height: 20),

            const Text(
              'Frequently Asked Questions (FAQ)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            _buildFAQTile(
              question: 'How can I reset my password?',
              answer:
                  'You can reset your password by going to the Settings page and clicking on "Change Password".',
            ),
            _buildFAQTile(
              question: 'How do I contact support?',
              answer:
                  'You can contact us through email (support@example.com) or call us at +1234567890.',
            ),
            const SizedBox(height: 20),

            const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                _showFeedbackDialog(context);
              },
              icon: const Icon(Icons.feedback),
              label: const Text('Send Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Submit Feedback',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              hintText: 'Enter your feedback',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle feedback submission here (e.g., send to server)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
