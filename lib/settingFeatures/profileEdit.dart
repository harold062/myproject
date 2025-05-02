import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String birthday = '';
  String gender = 'Male';

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save logic here (e.g., send to server or local storage)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  initialValue: name,
                  onSaved: (value) => name = value ?? '',
                  validator:
                      (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  initialValue: email,
                  onSaved: (value) => email = value ?? '',
                  validator:
                      (value) =>
                          value!.contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Birthday'),
                  initialValue: birthday,
                  onSaved: (value) => birthday = value ?? '',
                  validator:
                      (value) => value!.isEmpty ? 'Enter your birthday' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Gender'),
                  value: gender,
                  items:
                      ['Male', 'Female', 'Other']
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => gender = value!),
                  onSaved: (value) => gender = value ?? 'Male',
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Profile'),
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
