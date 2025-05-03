import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myproject/colors.dart';
import 'package:myproject/screens/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'Patient';

  Future<void> _navigateToRegistration() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim(); // Get name input
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty ||
        name.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar("Please fill out all fields");
    } else if (password != confirmPassword) {
      _showSnackBar("Passwords do not match");
    } else if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters");
    } else if (!email.contains('@')) {
      _showSnackBar("Please enter a valid email address");
    } else {
      try {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final user = userCredential.user;

        if (user != null) {
          await user.sendEmailVerification();

          // Store user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'email': email,
                'name': name, // Store name in the database
                'uname': username,
                'role': _selectedRole,
                'createdAt': FieldValue.serverTimestamp(),
              });

          // Optionally store locally for convenience
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setString('role', _selectedRole);

          await FirebaseAuth.instance.signOut();

          _showSnackBar(
            "A verification email has been sent to your email address. Please verify your email and log in.",
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LogInPage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        _showSnackBar("Signup failed: ${e.message}");
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage()),
      );
    } catch (e) {
      _showSnackBar("Google Sign-In failed: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose(); // Dispose name controller
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.1,
            20,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(_emailController, "Email", Icons.email),
              const SizedBox(height: 20),
              _buildTextField(
                _nameController,
                "Full Name",
                Icons.person,
              ), // Added name field
              const SizedBox(height: 20),
              _buildTextField(
                _usernameController,
                "Username",
                Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                _passwordController,
                "Password",
                _obscurePassword,
                (val) {
                  setState(() => _obscurePassword = val);
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                _confirmPasswordController,
                "Confirm Password",
                _obscureConfirmPassword,
                (val) {
                  setState(() => _obscureConfirmPassword = val);
                },
              ),
              const SizedBox(height: 20),
              _buildRoleDropdown(),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _navigateToRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildGoogleSignIn(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool obscure,
    Function(bool) toggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () => toggle(!obscure),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Registering as:",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        DropdownButton<String>(
          value: _selectedRole,
          dropdownColor: Colors.deepPurple,
          style: const TextStyle(color: Colors.white),
          items:
              ['Patient', 'Caregiver'].map((String role) {
                return DropdownMenuItem<String>(value: role, child: Text(role));
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return Column(
      children: [
        InkWell(
          onTap: _signInWithGoogle,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const FaIcon(FontAwesomeIcons.google, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Continue with Google",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
