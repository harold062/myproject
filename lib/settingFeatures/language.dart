import 'package:flutter/material.dart';
import 'package:myproject/profileFeatures/settings.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String selectedLanguage = 'English'; // default

  final List<String> languages = ['English', 'Filipino', 'Cebuano'];

  void _onLanguageChanged(String? newLang) {
    if (newLang != null) {
      setState(() {
        selectedLanguage = newLang;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language set to $newLang'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      // TODO: Save this to persistent storage (e.g., SharedPreferences) and apply localization
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language Settings',
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
        padding: const EdgeInsets.all(20.0),
        child: DropdownButtonFormField<String>(
          value: selectedLanguage,
          decoration: InputDecoration(
            labelText: 'Select Language',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items:
              languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
          onChanged: _onLanguageChanged,
        ),
      ),
    );
  }
}
