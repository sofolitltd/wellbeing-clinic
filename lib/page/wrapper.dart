import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/page/main_page.dart';
import 'auth/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // User is signed in
            return const MainPage();
          } else {
            // User is not signed in
            return LoginScreen();
          }
        },
      ),
    );
  }
}
