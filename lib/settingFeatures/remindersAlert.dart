import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/settings.dart';

class RemindersAndAlertsScreen extends StatefulWidget {
  const RemindersAndAlertsScreen({super.key});

  @override
  State<RemindersAndAlertsScreen> createState() =>
      _RemindersAndAlertsScreenState();
}

class _RemindersAndAlertsScreenState extends State<RemindersAndAlertsScreen> {
  List<String> reminders = [
    'Take medicine at 8:00 AM',
    'Check blood pressure at 2:00 PM',
  ];
  final _reminderController = TextEditingController();

  void _addReminder() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add Reminder'),
            content: TextField(
              controller: _reminderController,
              decoration: const InputDecoration(
                hintText: 'e.g., Drink water at 9 PM',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _reminderController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_reminderController.text.isNotEmpty) {
                    setState(() {
                      reminders.add(_reminderController.text);
                    });
                  }
                  _reminderController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders & Alerts'),
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
      body:
          reminders.isEmpty
              ? const Center(child: Text('No reminders yet.'))
              : ListView.builder(
                itemCount: reminders.length,
                itemBuilder:
                    (context, index) => ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Text(reminders[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReminder(index),
                      ),
                    ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
