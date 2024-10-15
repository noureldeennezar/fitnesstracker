import 'package:flutter/material.dart';
import 'package:fitnesstracker/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'logout.dart';

class Settings extends StatelessWidget {
  final Map<String, dynamic> user; // Accept user data

  const Settings({super.key, required this.user}); // Update constructor to require user data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900], // Match the color of your HomeScreen's app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded), // Back button
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(user: user)), // Pass user data back
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          children: [
            const Text(
              'Settings Options', // Add a section title
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Space between the title and the buttons
            ElevatedButton(
              onPressed: () async {
                await logout(); // Clear user session
                Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login screen
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red, backgroundColor: Colors.white, // Button text color
                side: const BorderSide(color: Colors.red), // Button border color
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 20), // Space between buttons
            // You can add more settings options here
          ],
        ),
      ),
    );
  }
}
