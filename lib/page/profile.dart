import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  DocumentSnapshot<Map<String, dynamic>>? userDoc;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          error = 'User not logged in.';
          isLoading = false;
        });
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (!doc.exists) {
        setState(() {
          error = 'User data not found.';
          isLoading = false;
        });
        return;
      }

      setState(() {
        userDoc = doc;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(child: Text(error!)),
      );
    }

    final data = userDoc!.data()!;
    final name = '${data['firstName']} ${data['lastName']}' ?? ' HEllO';
    final email = user!.email ?? 'No Email';
    final mobile = data['mobile'] ?? 'No Phone';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.indigo.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            children: [
              Divider(height: 1, thickness: .5),
              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                    //shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.indigo.shade100,
                                  child: ClipOval(
                                    child: Icon(Icons.person,
                                        size: 50,
                                        color: Colors.indigo.shade400),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 6,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.indigo.shade700,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.white),
                                      onPressed: () {
                                        // TODO: Edit avatar
                                      },
                                      iconSize: 16,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 16),

                            // Name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade900,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Email
                                Text(
                                  email,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.indigo.shade700,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Info fields with icons
                        _infoRow(Icons.phone, 'Phone', mobile),
                        const SizedBox(height: 18),
                        _infoRow(Icons.info_outline, 'Bio', ''),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              visualDensity: VisualDensity.comfortable,
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(6),
                              // ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Confirm Logout',
                                middleText: 'Are you sure you want to log out?',
                                textCancel: 'Cancel',
                                textConfirm: 'Logout',
                                confirmTextColor: Colors.white,
                                onConfirm: () async {
                                  Get.back(); // close the dialog
                                  try {
                                    await FirebaseAuth.instance.signOut();
                                    Get.offAllNamed('/login');
                                  } catch (_) {
                                    Get.snackbar('Error', 'Logout failed');
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String content) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo.shade700, size: 26),
        const SizedBox(width: 16),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade800,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: Colors.indigo.shade600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
