import 'package:cloud_firestore/cloud_firestore.dart' hide Settings;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/profileFeatures/settings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String uname = '';
  String name = '';
  String email = '';
  String birthday = '';
  String gender = 'Male';
  String phoneNo = '';
  String age = '';
  String homeAdd = '';
  String? selectedAvatarUrl;
  bool _isLoading = true;

  final List<String> avatarUrls = [
    'https://i.imgur.com/xmk1FCe.png',
    'https://i.imgur.com/0czzlyF.png',
  ];

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
            selectedAvatarUrl = userDoc['profileImage'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _chooseAvatar() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            itemCount: avatarUrls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final avatarUrl = avatarUrls[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatarUrl = avatarUrl;
                  });
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 40,
                ),
              );
            },
          ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 60,
      backgroundImage: NetworkImage(
        selectedAvatarUrl ?? 'https://i.imgur.com/G5PevHF.jpg',
      ),
    );
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
                'profileImage': selectedAvatarUrl ?? '',
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
                        _buildProfileImage(),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                            ),
                            onPressed: _chooseAvatar,
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
                        _buildTextField(
                          'Username',
                          uname,
                          (val) => uname = val!,
                        ),
                        _buildTextField(
                          'Full Name',
                          name,
                          (val) => name = val!,
                        ),
                        _buildTextField('Age', age, (val) => age = val!),
                        _buildTextField(
                          'Contact Number',
                          phoneNo,
                          (val) => phoneNo = val!,
                        ),
                        _buildTextField(
                          'Email',
                          email,
                          (val) => email = val!,
                          validator:
                              (val) =>
                                  val!.contains('@')
                                      ? null
                                      : 'Enter a valid email',
                        ),
                        _buildBirthdayField(),
                        _buildTextField(
                          'Home Address',
                          homeAdd,
                          (val) => homeAdd = val!,
                        ),
                        _buildGenderDropdown(),
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

  Widget _buildTextField(
    String label,
    String initialValue,
    Function(String?) onSaved, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        initialValue: initialValue,
        onSaved: onSaved,
        validator:
            validator ??
            (value) => value!.isEmpty ? 'Please enter your $label' : null,
      ),
    );
  }

  Widget _buildBirthdayField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Birthday',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
            (value) => value!.isEmpty ? 'Please select your birthday' : null,
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        value: gender,
        items:
            [
              'Male',
              'Female',
              'Other',
            ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (value) => setState(() => gender = value!),
        onSaved: (value) => gender = value ?? 'Male',
      ),
    );
  }
}
