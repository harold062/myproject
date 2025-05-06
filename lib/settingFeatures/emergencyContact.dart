import 'package:flutter/material.dart';
import 'package:myproject/screens/profile.dart';
import 'package:myproject/screens/home.dart' as home;

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  int _currentIndex = 1; // Default to "Emergency Contacts" tab

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
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new contact functionality
        },
        backgroundColor: Colors.indigo[900], // Background color of the button
        child: const Icon(
          Icons.add,
          color: Colors.white, // Set the plus sign color to white
        ),
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
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              // Edit functionality
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
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          _buildContactCard(
                            name: 'John S. Doe',
                            phone: '+0912 3456 7891',
                            description: 'Guardian',
                            isOnline: true,
                          ),
                          _buildContactCard(
                            name: 'ABC HOSPITAL',
                            phone: '+0912 3456 7891',
                            description: 'Primary emergency dial',
                          ),
                          _buildContactCard(
                            name: 'Barangay Emergency Responders',
                            phone: '+0912 3456 7891',
                            description: 'Primary emergency dial',
                          ),
                          _buildContactCard(
                            name: 'National Emergency Hotline',
                            phone: '911',
                            description: 'Primary emergency dial',
                          ),
                        ],
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
            icon: Icon(Icons.person),
            label: '', // No label
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String name,
    required String phone,
    required String description,
    bool isOnline = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOnline ? Colors.green : Colors.blueAccent,
          child: Icon(
            isOnline ? Icons.check_circle : Icons.phone,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phone,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: isOnline ? Colors.green : Colors.black54,
                fontWeight: isOnline ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.blue),
          onPressed: () {
            // Call functionality
          },
        ),
      ),
    );
  }
}
