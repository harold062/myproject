import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/settings.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help and Support'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Email: support@example.com'),
            const Text('Phone: +1234567890'),
            const Text('Website: www.example.com'),
            const SizedBox(height: 20),

            const Text(
              'Frequently Asked Questions (FAQ)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: const Text('How can I reset my password?'),
              children: const [
                Text(
                  'You can reset your password by going to the Settings page and clicking on "Change Password".',
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('How do I contact support?'),
              children: const [
                Text(
                  'You can contact us through email (support@example.com) or call us at +1234567890.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Submit Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Show feedback dialog
                _showFeedbackDialog(context);
              },
              child: const Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the feedback dialog
  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Feedback'),
          content: TextField(
            controller: feedbackController,
            decoration: const InputDecoration(hintText: 'Enter your feedback'),
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
