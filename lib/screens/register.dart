// registration_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myproject/colors.dart';
import 'package:myproject/screens/home.dart';
import 'package:myproject/screens/login.dart';

class RegistrationPage extends StatefulWidget {
  final String email;
  final String username;
  final String password;

  const RegistrationPage({
    super.key,
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String _userType = 'patient';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signUpAndNavigate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(widget.username);
        await userCredential.user!.reload();

        DatabaseReference userRef = FirebaseDatabase.instance
            .ref()
            .child(_userType)
            .child(userCredential.user!.uid);
        await userRef.set({
          'username': widget.username,
          'email': widget.email,
          'userType': _userType,
          // Add other relevant information here based on user type
        });

        // Navigate to the appropriate screen
        if (_userType == 'patient') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ), // Replace with your actual patient home page
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Text('Caregiver Home Screen'),
            ), // Replace with your actual caregiver home screen
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _handleFirebaseError(e.code);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred';
      });
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _handleFirebaseError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An error occurred during registration.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                hexStringToColor("B0E0E6"),
                hexStringToColor("7B68EE"),
                hexStringToColor("005A9C"),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Complete Registration",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Registering as:'),
                  DropdownButton<String>(
                    value: _userType,
                    items:
                        <String>['patient', 'caregiver'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.capitalize()),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _userType = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUpAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hexStringToColor("005A9C"),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringCasingExtension on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
