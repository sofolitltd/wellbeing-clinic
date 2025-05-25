import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      setState(() {
        _message = 'Password reset email sent! Please check your inbox.';
        _isError = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? 'An error occurred. Please try again.';
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
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
                          'assets/logo.png',
                          height: 40,
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Wellbeing Clinic',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter your email below and we will send instructions to reset your password.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
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
                              'Taking care of your mental health is our priority. We’re here to help.',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '— Wellbeing Clinic Team',
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
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //
                            if (isMobile)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 80,
                                ),
                              ),

                            //
                            Text(
                              'Reset your password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 24 : 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Enter your email address below and we'll send you instructions to reset your password.",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration('Email'),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(val)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                              autofillHints: const [AutofillHints.email],
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB9C7F8),
                                foregroundColor: Colors.black87,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black87,
                                      ),
                                    )
                                  : const Text('Send Reset Email'),
                            ),
                            if (_message != null) ...[
                              const SizedBox(height: 20),
                              Text(
                                _message!,
                                style: TextStyle(
                                  color: _isError ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 40),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Back to Login',
                                style: TextStyle(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
