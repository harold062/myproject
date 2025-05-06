import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/screens/profile.dart';
import 'package:myproject/settingFeatures/emergencyContact.dart'
    as emergency; // Alias for EmergencyContactsScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userId;
  Map<String, dynamic>? userData;
  bool _isLoading = true;
  bool _isSelected = false;
  int _currentIndex = 0; // Default to "Home" tab

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        userId = user.uid;
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            _isLoading = false;
          });
        } else {
          print('User document not found');
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Home Screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const emergency.EmergencyContactsScreen(),
          ),
        );
        break;
      case 2:
        // Navigate to Favorites/Starred Screen
        break;
      case 3:
        // Navigate to Profile Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
              ? const Center(
                child: Text(
                  'No user data found.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      icon: Icons.person,
                      label: 'Name',
                      value: userData!['name'] ?? 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.account_circle,
                      label: 'Username',
                      value: userData!['uname'] ?? 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.email,
                      label: 'Email',
                      value: userData!['email'] ?? 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.badge,
                      label: 'Role',
                      value: userData!['role'] ?? 'N/A',
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            Colors.deepPurple, // Highlighted color for selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons
        showSelectedLabels: false, // Hide labels
        showUnselectedLabels: false, // Hide labels
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '', // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '', // No label
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
