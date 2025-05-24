import 'dart:async';

import 'package:flutter/material.dart';

class GroundingPage extends StatefulWidget {
  const GroundingPage({super.key});

  @override
  State<GroundingPage> createState() => _GroundingPageState();
}

class _GroundingPageState extends State<GroundingPage> {
  int _currentStepIndex =
      -1; // -1: Intro/Ready, 0-4: Active Steps, 5: Completed
  bool _isExerciseActive = false;
  Timer? _promptTimer; // Timer for cycling through sub-prompts within a step
  int _currentPromptSubIndex = 0; // Index for current sub-prompt within a step

  // Introduction and Disclaimer
  final String _groundingIntroBn =
      "5-4-3-2-1 গ্রাউন্ডিং কৌশল হলো উদ্বেগ, আতঙ্ক বা অপ্রতিরোধ্য অনুভূতির সময় আপনার মনকে বর্তমান মুহূর্তে ফিরিয়ে আনার একটি সহজ এবং কার্যকর পদ্ধতি। এটি আপনার ইন্দ্রিয়গুলোকে ব্যবহার করে আপনাকে আপনার চারপাশের সাথে সংযুক্ত করে, মানসিক চাপ কমাতে এবং শান্ত অনুভব করতে সাহায্য করে।";
  // The 5-4-3-2-1 grounding technique is a simple and effective method to bring your mind back to the present moment during times of anxiety, panic, or overwhelming emotions. It uses your senses to connect you with your surroundings, helping to reduce mental stress and feel calm.

  final String _disclaimerBn =
      "**গুরুত্বপূর্ণ দ্রষ্টব্য:** এই অনুশীলনটি একটি স্ব-সহায়ক সরঞ্জাম এবং পেশাদার থেরাপি বা চিকিৎসার বিকল্প নয়। আপনার যদি গুরুতর উদ্বেগ বা মানসিক স্বাস্থ্য সংক্রান্ত সমস্যা থাকে, তাহলে একজন যোগ্যতাসম্পয় মানসিক স্বাস্থ্য পেশাদারের পরামর্শ নিন।";
  // Note: This exercise is a self-help tool and is not a substitute for professional therapy or treatment. If you have severe anxiety or mental health issues, please consult a qualified mental health professional.

  // Core Grounding Steps with Bengali text and more detailed sub-prompts
  final List<Map<String, dynamic>> _groundingStepsDetails = const [
    {
      'count': '৫টি',
      'sense': 'জিনিস যা আপনি দেখতে পাচ্ছেন',
      'icon': Icons.visibility,
      'prompts': [
        'আপনার চারপাশের দিকে তাকান। ৫টি ভিন্ন জিনিস লক্ষ্য করুন।',
        'রং, আকার, টেক্সচার এবং তাদের অবস্থান খেয়াল করুন।',
        'কোনো বিশদ বিবরণ যা সাধারণত আপনার নজরে পড়ে না, সেটি লক্ষ্য করুন।',
      ],
    },
    {
      'count': '৪টি',
      'sense': 'জিনিস যা আপনি স্পর্শ করতে পারছেন',
      'icon': Icons.touch_app,
      'prompts': [
        'আপনার হাত দিয়ে বা শরীর দিয়ে ৪টি ভিন্ন জিনিস স্পর্শ করুন।',
        'আপনার পোশাকের কাপড় অনুভব করুন, চেয়ারের টেক্সচার বা মেঝেতে আপনার পায়ের অনুভূতি।',
        'ঠান্ডা, উষ্ণ, নরম বা শক্ত - কেমন অনুভব করছেন?',
      ],
    },
    {
      'count': '৩টি',
      'sense': 'জিনিস যা আপনি শুনতে পাচ্ছেন',
      'icon': Icons.hearing,
      'prompts': [
        '৩টি ভিন্ন শব্দ মনোযোগ দিয়ে শুনুন।',
        'পাখির কিচিরমিচির, গাড়ির শব্দ, আপনার শ্বাস-প্রশ্বাস, বা ঘরের কোলাহল।',
        'দূরের এবং কাছের শব্দগুলো আলাদা করে চিনুন।',
      ],
    },
    {
      'count': '২টি',
      'sense': 'জিনিস যা আপনি গন্ধ নিতে পারছেন',
      'icon': Icons.flare, // Using a more abstract but fitting icon for smell
      'prompts': [
        '২টি ভিন্ন গন্ধের প্রতি মনোযোগ দিন।',
        'আপনার কফি, পারফিউম, প্রকৃতির গন্ধ বা ঘরের পরিচিত গন্ধ।',
        'আপনার আশেপাশে কি কোনো মিষ্টি বা অন্য কোনো গন্ধ আছে?',
      ],
    },
    {
      'count': '১টি',
      'sense': 'জিনিস যা আপনি স্বাদ নিতে পারছেন',
      'icon': Icons.restaurant_menu, // More specific to taste
      'prompts': [
        'আপনার মুখে একটি জিনিসের স্বাদ অনুভব করুন।',
        'এটি হতে পারে চুইংগাম, এক গ্লাস পানি বা আপনার মুখের স্বাদ।',
        'স্বাদটা কেমন? মিষ্টি, নোনতা, টক, নাকি অন্য কিছু?',
      ],
    },
  ];

  @override
  void dispose() {
    _promptTimer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _currentStepIndex = 0;
      _isExerciseActive = true;
      _currentPromptSubIndex = 0;
    });
    _startPromptTimer();
  }

  void _startPromptTimer() {
    _promptTimer?.cancel();
    if (_currentStepIndex >= 0 &&
        _currentStepIndex < _groundingStepsDetails.length) {
      final currentPrompts =
          _groundingStepsDetails[_currentStepIndex]['prompts'] as List<String>;
      if (currentPrompts.length > 1) {
        _promptTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
          setState(() {
            _currentPromptSubIndex =
                (_currentPromptSubIndex + 1) % currentPrompts.length;
          });
        });
      }
    }
  }

  void _nextStep() {
    _promptTimer?.cancel();
    setState(() {
      if (_currentStepIndex < _groundingStepsDetails.length - 1) {
        _currentStepIndex++;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      } else {
        _currentStepIndex = 5; // Indicate completion
        _isExerciseActive = false;
      }
    });
  }

  void _resetExercise() {
    _promptTimer?.cancel();
    setState(() {
      _currentStepIndex = -1;
      _isExerciseActive = false;
      _currentPromptSubIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Consistent white background
      appBar: AppBar(
        title: const Text(
          "গ্রাউন্ডিং অনুশীলন", // Grounding Exercise
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.lightBlue.shade700, // Consistent AppBar color
        elevation: 4, // Consistent shadow for depth
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Progress Indicator (Consistent with CBT Page) ---
              if (_currentStepIndex > -1 &&
                  _currentStepIndex < _groundingStepsDetails.length)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(_groundingStepsDetails.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentStepIndex == index ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentStepIndex == index
                              ? Colors.lightBlue.shade700
                              : Colors.lightBlue.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              // --- Main Content Area (No Card) ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25.0), // Consistent padding
                  child: _currentStepIndex == -1 // Intro/Ready State
                      ? _buildIntroAndDisclaimer()
                      : _currentStepIndex == 5 // Completed State
                          ? _buildCompletionState()
                          : _buildActiveExerciseStep(), // Active Step State
                ),
              ),
              // --- Action Buttons (Consistent with CBT Page) ---
              Padding(
                padding: const EdgeInsets.all(25.0), // Consistent padding
                child: SizedBox(
                  width: double.infinity, // Full width button
                  child: _buildActionButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the introduction and disclaimer section
  Widget _buildIntroAndDisclaimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "5-4-3-2-1 গ্রাউন্ডিং কৌশল", // 5-4-3-2-1 Grounding Technique
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue.shade800),
        ),
        const SizedBox(height: 20),
        Text(
          _groundingIntroBn,
          style:
              const TextStyle(fontSize: 17, height: 1.6, color: Colors.black87),
        ),
        const Spacer(),
        Container(
          // Disclaimer container styling consistent with CBT page
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Text(
            _disclaimerBn,
            style: TextStyle(
              fontSize: 13,
              color: Colors.red.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 20), // Spacer for button
      ],
    );
  }

  // Widget to build the active exercise step
  Widget _buildActiveExerciseStep() {
    final currentStep = _groundingStepsDetails[_currentStepIndex];
    final List<String> prompts = currentStep['prompts'];
    final String currentPrompt = prompts[_currentPromptSubIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(currentStep['icon'] as IconData,
            size: 80,
            color: Colors.lightBlue.shade700), // Consistent icon color
        const SizedBox(height: 20),
        Text(
          currentStep['count']!,
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue.shade800, // Consistent text color
          ),
        ),
        Text(
          currentStep['sense']!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 30),
        // Display current sub-prompt
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            currentPrompt,
            key: ValueKey<int>(_currentPromptSubIndex), // Key for animation
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget to build the completion state
  Widget _buildCompletionState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline,
            size: 80, color: Colors.green.shade600),
        const SizedBox(height: 16),
        Text(
          "অভিনন্দন! আপনি গ্রাউন্ডিং অনুশীলনটি সফলভাবে সম্পন্ন করেছেন। আশা করি আপনি এখন আরও শান্ত এবং বর্তমান মুহূর্তে আছেন।",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "আপনি যখনই অপ্রতিরোধ্য বা উদ্বেগ অনুভব করেন, তখন এই অনুশীলনটি আবার ব্যবহার করতে পারেন।",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // Unified Action Button (Start, Next, Finish, Restart)
  Widget _buildActionButton() {
    String buttonText;
    IconData buttonIcon;
    Color buttonColor;
    VoidCallback onPressedAction;

    if (_currentStepIndex == -1) {
      buttonText = "অনুশীলন শুরু করুন"; // Start Exercise
      buttonIcon = Icons.play_arrow;
      buttonColor =
          Colors.lightBlue.shade700; // Consistent primary action color
      onPressedAction = _startExercise;
    } else if (_currentStepIndex == _groundingStepsDetails.length) {
      buttonText = "আবার শুরু করুন"; // Start Again
      buttonIcon = Icons.refresh;
      buttonColor =
          Colors.lightBlue.shade500; // Slightly lighter for secondary action
      onPressedAction = _resetExercise;
    } else {
      buttonText = _currentStepIndex == _groundingStepsDetails.length - 1
          ? 'অনুশীলন শেষ করুন' // Finish Exercise
          : 'পরবর্তী ধাপ'; // Next Step (changed from "This step is done" for clearer flow)
      buttonIcon = _currentStepIndex == _groundingStepsDetails.length - 1
          ? Icons.check_circle_outline
          : Icons.arrow_forward;
      buttonColor = Colors.lightBlue.shade700;
      onPressedAction = _nextStep;
    }

    return ElevatedButton.icon(
      onPressed: onPressedAction,
      label: Text(
        buttonText,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      icon: Icon(buttonIcon, color: Colors.white),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12)), // Slightly rounded corners
        elevation: 4, // Subtle shadow for depth
      ),
    );
  }
}
