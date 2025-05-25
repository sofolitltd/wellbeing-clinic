import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Using Future.delayed to ensure navigation happens after build
        Future.delayed(Duration.zero, () {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              // User is signed in
              if (Get.currentRoute != '/home') {
                // Avoid redundant navigation
                Get.offAllNamed('/home'); // or Get.offNamed('/main')
              }
            } else {
              // User is not signed in
              if (Get.currentRoute != '/login') {
                // Avoid redundant navigation
                Get.offAllNamed('/login'); // or Get.offNamed('/login')
              }
            }
          }
        });

        // Display a loading indicator while checking auth state
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
