import 'package:cloud_firestore/cloud_firestore.dart' hide Settings;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/profileFeatures/settings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  String uname = '';
  String name = '';
  String email = '';
  String birthday = '';
  String gender = 'Male';
  String phoneNo = '';
  String age = '';
  String homeAdd = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            uname = userDoc['uname'] ?? '';
            name = userDoc['name'] ?? '';
            email = userDoc['email'] ?? '';
            birthday = userDoc['birthday'] ?? '';
            gender = userDoc['gender'] ?? 'Male';
            phoneNo = userDoc['phoneNo'] ?? '';
            age = userDoc['age'] ?? '';
            homeAdd = userDoc['homeAdd'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
                'uname': uname,
                'name': name,
                'email': email,
                'birthday': birthday,
                'gender': gender,
                'phoneNo': phoneNo,
                'age': age,
                'homeAdd': homeAdd,
                'profileImage':
                    _profileImage != null ? _profileImage!.path : null,
              });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Settings()),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
              (route) => false,
            );
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage('assets/images/logo.png')
                                      as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.blueAccent,
                            ),
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
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialValue: uname,
                          onSaved: (value) => uname = value ?? '',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your username'
                                      : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialValue: name,
                          onSaved: (value) => name = value ?? '',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your name'
                                      : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialValue: age,
                          onSaved: (value) => age = value ?? '',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your age'
                                      : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialValue: phoneNo,
                          onSaved: (value) => phoneNo = value ?? '',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your contact number'
                                      : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialValue: email,
                          onSaved: (value) => email = value ?? '',
                          validator:
                              (value) =>
                                  value!.contains('@')
                                      ? null
                                      : 'Enter a valid email',
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Birthday',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    birthday =
                                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                  });
                                }
                              },
                            ),
                          ),
                          controller: TextEditingController(text: birthday),
                          readOnly: true,
                          onSaved: (value) => birthday = value ?? '',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please select your birthday'
                                      : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Home Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialValue: homeAdd,
                          onSaved: (value) => homeAdd = value ?? '',
                          validator:
                              (value) =>
                                  value!.isEmpty
                                      ? 'Please enter your home address'
                                      : null,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          value: gender,
                          items:
                              ['Male', 'Female', 'Other']
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    ),
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
                ],
              ),
    );
  }
}
