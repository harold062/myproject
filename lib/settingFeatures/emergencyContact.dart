import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/screens/profile.dart' as profile;
import 'package:myproject/screens/home.dart' as home;

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int _currentIndex = 1; // Default to "Emergency Contacts" tab
  bool _isEditing = false; // Tracks whether the "Edit" mode is active

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Home Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const home.HomeScreen()),
        );
        break;
      case 1:
        // Stay on Emergency Contacts Screen
        break;
      case 2:
        // Navigate to Favorites/Starred Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const profile.ProfileScreen(),
          ),
        );
        break;
    }
  }

  Future<void> _addOrEditContact({String? id}) async {
    _nameController.clear();
    _phoneController.clear();
    _descriptionController.clear();

    if (id != null) {
      // If editing, pre-fill the fields with existing data
      DocumentSnapshot doc =
          await _firestore.collection('contacts').doc(id).get();
      _nameController.text = doc['name'];
      _phoneController.text = doc['phone'];
      _descriptionController.text = doc['description'];
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(id == null ? 'Add Contact' : 'Edit Contact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    // Add new contact
                    await _firestore.collection('contacts').add({
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'description': _descriptionController.text,
                    });
                  } else {
                    // Update existing contact
                    await _firestore.collection('contacts').doc(id).update({
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'description': _descriptionController.text,
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteContact(String id) async {
    await _firestore.collection('contacts').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditContact(),
        backgroundColor: Colors.indigo[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(),
        child: ClipRRect(
          child: Stack(
            children: [
              // White background for the entire container
              Container(color: Colors.white),
              // Blue gradient at the top part (approximately 40% of height)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: screenHeight * 0.4, // 40% of screen height
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue.shade300,
                        Colors.blue.shade100.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Add content from the image
              Positioned.fill(
                child: Column(
                  children: [
                    // App Bar with Edit button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          TextButton(
                            child: Text(
                              _isEditing ? 'Done' : 'Edit',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // Swipe right to trigger alert
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, // 5% of screen width
                      ),
                      child: Container(
                        height: 40, // Reduced height
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13.0),
                              child: Text(
                                'Swipe right to trigger alert',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Hot Dials title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hot Dials',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // List of contacts
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('contacts').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No contacts found.'),
                            );
                          }

                          final contacts = snapshot.data!.docs;

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return _buildContactCard(
                                id: contact.id,
                                name: contact['name'],
                                phone: contact['phone'],
                                description: contact['description'],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String id,
    required String name,
    required String phone,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.phone, color: Colors.white),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phone, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing:
            _isEditing
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _addOrEditContact(id: id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteContact(id),
                    ),
                  ],
                )
                : IconButton(
                  icon: const Icon(Icons.phone, color: Colors.blue),
                  onPressed: () {
                    // Call functionality
                  },
                ),
      ),
    );
  }
}

// Dummy Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}
