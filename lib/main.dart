import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myproject/profileFeatures/settings.dart';
import 'package:myproject/screens/home.dart' as home;
import 'package:myproject/screens/login.dart';
import 'package:myproject/screens/profile.dart';
import 'package:myproject/screens/register.dart';
import 'firebase_options.dart'; // Import generated firebase config

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Using generated options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter Firebase App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const home.HomeScreen();
          } else {
            return const LogInPage();
          }
        },
      ),
    );
  }
}
