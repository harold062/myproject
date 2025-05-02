import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/settings.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String method = 'Email';
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _codeController = TextEditingController();
  bool codeSent = false;

  void _sendCode() {
    // Placeholder for sending code via email or SMS
    setState(() {
      codeSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verification code sent via $method')),
    );
  }

  void _changePassword() {
    // Implement actual password change logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password successfully changed')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Settings()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
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
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Choose method'),
              value: method,
              items: const [
                DropdownMenuItem(value: 'Email', child: Text('Email')),
                DropdownMenuItem(value: 'SMS', child: Text('SMS')),
              ],
              onChanged: (value) {
                setState(() {
                  method = value!;
                  codeSent = false;
                });
              },
            ),
            const SizedBox(height: 10),
            if (method == 'Email')
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                ),
              ),
            if (method == 'SMS')
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Enter your phone number',
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _sendCode,
              icon: const Icon(Icons.send),
              label: const Text('Send Verification Code'),
            ),
            if (codeSent) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Enter verification code',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter new password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _changePassword,
                icon: const Icon(Icons.lock_reset),
                label: const Text('Change Password'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
