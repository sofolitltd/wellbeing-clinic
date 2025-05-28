import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/set_tab_title.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isGoogleLoading = false;
  bool _isEmailLoading = false;

  bool _passwordVisible = false;

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  //
  // Future<void> handleGoogleSignIn() async {
  //   setState(() {
  //     _isGoogleLoading = true;
  //   });
  //
  //   try {
  //     UserCredential userCredential;
  //
  //     if (kIsWeb) {
  //       // Web sign-in
  //       GoogleAuthProvider googleProvider = GoogleAuthProvider()
  //         ..addScope('https://www.googleapis.com/auth/contacts.readonly');
  //
  //       await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  //       userCredential = await FirebaseAuth.instance.getRedirectResult();
  //     } else {
  //       // Android/iOS sign-in
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //       if (googleUser == null) {
  //         // Cancelled
  //         setState(() {
  //           _isGoogleLoading = false;
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Google Sign-In cancelled')),
  //         );
  //         return;
  //       }
  //
  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;
  //
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //
  //       userCredential =
  //           await FirebaseAuth.instance.signInWithCredential(credential);
  //     }
  //
  //     //
  //     if (userCredential.user != null) {
  //       log('Google Sign-In successful:${userCredential}');
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Google Sign-In successful')),
  //       );
  //       Get.offAllNamed('/home');
  //     } else {
  //       log('Google Sign-In failed');
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Google Sign-In failed')),
  //       );
  //     }
  //   } catch (e) {
  //     log('Google Sign-In error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isGoogleLoading = false;
  //     });
  //   }
  // }

  // Future<void> _handleGoogleSignIn() async {
  //   setState(() {
  //     _isGoogleLoading = true;
  //   });
  //
  //   try {
  //     final googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser == null) {
  //       setState(() {
  //         _isGoogleLoading = false;
  //       });
  //       return; // User canceled sign-in
  //     }
  //
  //     final googleAuth = await googleUser.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     final user = userCredential.user;
  //
  //     if (user != null) {
  //       // Add user to Firestore or any other logic here if needed
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Google Sign-In successful')),
  //       );
  //       //
  //       Get.offAllNamed('/home');
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Google Sign-In failed')),
  //       );
  //     }
  //   } catch (e) {
  //     log('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isGoogleLoading = false;
  //     });
  //   }
  // }

  Future<void> _handleEmailSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isEmailLoading = true;
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        Get.offAllNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      setState(() {
        _isEmailLoading = false;
      });
    }
  }

  void _goToForgotPassword() {
    Get.toNamed('/forgot-password'); // Your forgot password route
  }

  @override
  Widget build(BuildContext context) {
    setTabTitle('Login - Wellbeing Clinic', context);

    final isMobile = MediaQuery.of(context).size.width < 768;

    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (!isMobile)
              Expanded(
                child: Container(
                  color: const Color(0xFFF7F8FC),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo.png', // Your logo
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Wellbeing Clinic',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Your mental health matters. Get support that fits your life.',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Trusted by many people to improve their emotional wellbeing.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 32),
                      const Card(
                        color: Color(0xFFE7ECFB),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.format_quote,
                                  color: Colors.blue, size: 30),
                              SizedBox(height: 8),
                              Text(
                                'I felt heard, supported, and understood. This clinic helped me regain balance in my life.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '~ ',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Log in to Wellbeing Clinic',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          const SizedBox(height: 24),
                          // OutlinedButton.icon(
                          //   icon: _isGoogleLoading
                          //       ? Stack(
                          //           children: [
                          //             Image.network(
                          //               'https://img.icons8.com/color/512/google-logo.png',
                          //               height: 20,
                          //               //gray scale
                          //               color: Colors.grey,
                          //             ),
                          //             const SizedBox(
                          //               height: 20,
                          //               width: 20,
                          //               child: CircularProgressIndicator(
                          //                   strokeWidth: 2),
                          //             ),
                          //           ],
                          //         )
                          //       : Image.network(
                          //           'https://img.icons8.com/color/512/google-logo.png',
                          //           height: 20),
                          //   label: const Text('Continue with Google'),
                          //   onPressed:
                          //       _isGoogleLoading ? null : handleGoogleSignIn,
                          //   style: OutlinedButton.styleFrom(
                          //     padding: const EdgeInsets.symmetric(vertical: 16),
                          //   ),
                          // ),
                          // const SizedBox(height: 24),
                          // Row(children: const [
                          //   Expanded(child: Divider()),
                          //   Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 8),
                          //     child: Text("or"),
                          //   ),
                          //   Expanded(child: Divider()),
                          // ]),
                          // const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: inputDecoration('Email'),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(val)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_passwordFocus),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: !_passwordVisible,
                            textInputAction: TextInputAction.done,
                            decoration: inputDecoration('Password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (val.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _handleEmailSignIn(),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _goToForgotPassword,
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed:
                                _isEmailLoading ? null : _handleEmailSignIn,
                            style: ElevatedButton.styleFrom(
                              visualDensity: VisualDensity.comfortable,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: Colors.blueAccent.shade700,
                              foregroundColor: Colors.black87,
                            ),
                            child: _isEmailLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black87,
                                    ),
                                  )
                                : Text(
                                    'Proceed',
                                    style: TextStyle(
                                      color: _isEmailLoading
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don’t have an account? "),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed('/register');
                                },
                                child: const Text('Sign up'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
