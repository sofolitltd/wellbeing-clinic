import 'dart:async'; // Required for Timer

import 'package:flutter/material.dart';

class PMRPage extends StatefulWidget {
  const PMRPage({super.key});

  @override
  State<PMRPage> createState() => _PMRPageState();
}

class _PMRPageState extends State<PMRPage> {
  int _currentStepIndex =
      -1; // -1: Intro/Ready, 0-N: Active Steps, N+1: Completed
  bool _isExerciseActive = false;
  Timer? _promptTimer; // Timer for cycling through sub-prompts within a step
  int _currentPromptSubIndex = 0; // Index for current sub-prompt within a step

  // Introduction and Disclaimer for PMR
  final String _pmrIntroBn =
      "প্রগ্রেসিভ মাসল রিল্যাক্সেশন (PMR) হলো উদ্বেগ ও মানসিক চাপ কমানোর একটি কার্যকরী কৌশল। এটিতে আপনার শরীরের বিভিন্ন পেশী গোষ্ঠীকে ক্রমান্বয়ে টান টান করা এবং তারপর শিথিল করা জড়িত। এর মাধ্যমে আপনি উত্তেজনা এবং গভীর শিথিলতার মধ্যে পার্থক্য চিনতে শিখবেন, যা শারীরিক ও মানসিক চাপমুক্তিতে সহায়তা করে।";
  // Progressive Muscle Relaxation (PMR) is an effective technique for reducing anxiety and stress. It involves systematically tensing and then relaxing various muscle groups in your body. Through this, you will learn to recognize the difference between tension and deep relaxation, which helps in releasing physical and mental stress.

  final String _disclaimerBn =
      "**গুরুত্বপূর্ণ দ্রষ্টব্য:** এই অনুশীলনটি একটি স্ব-সহায়ক সরঞ্জাম এবং পেশাদার থেরাপি বা চিকিৎসার বিকল্প নয়। আপনার যদি গুরুতর উদ্বেগ বা মানসিক স্বাস্থ্য সংক্রান্ত সমস্যা থাকে, তাহলে একজন যোগ্যতাসম্পন্ন মানসিক স্বাস্থ্য পেশাদারের পরামর্শ নিন।";
  // Important Note: This exercise is a self-help tool and is not a substitute for professional therapy or treatment. If you have severe anxiety or mental health issues, please consult a qualified mental health professional.

  // Core PMR Steps with Bengali text and more detailed sub-prompts
  final List<Map<String, dynamic>> _pmrStepsDetails = const [
    {
      'title': 'ভূমিকা ও প্রস্তুতি', // Introduction & Preparation
      'icon': Icons.self_improvement,
      'prompts': [
        'একটি শান্ত এবং আরামদায়ক জায়গা খুঁজুন।',
        'আরামদায়ক পোশাক পরুন।',
        'আরাম করে বসুন বা শুয়ে পড়ুন।',
        'কিছু গভীর শ্বাস নিয়ে নিজেকে প্রস্তুত করুন।',
      ],
    },
    {
      'title': 'হাত ও বাহু', // Hands & Arms
      'icon': Icons.accessibility_new,
      'prompts': [
        'আপনার ডান হাত মুষ্টিবদ্ধ করুন। আপনার হাত ও বাহুতে টান অনুভব করুন।',
        '৭ সেকেন্ড ধরে রাখুন।',
        'এবার ধীরে ধীরে ছেড়ে দিন। আপনার হাত সম্পূর্ণ নরম হয়ে যাবে। উত্তেজনা ও শিথিলতার পার্থক্য অনুভব করুন। (বাম হাতের জন্য পুনরাবৃত্তি করুন)',
      ],
    },
    {
      'title': 'কাঁধ ও ঘাড়', // Shoulders & Neck
      'icon': Icons.wc, // A general icon for upper body
      'prompts': [
        'আপনার কাঁধ দুটি কান পর্যন্ত উপরে তুলুন। ঘাড় ও কাঁধে উত্তেজনা অনুভব করুন।',
        '৭ সেকেন্ড ধরে রাখুন।',
        'ধীরে ধীরে ছেড়ে দিন। আপনার কাঁধ নিচে নামুক এবং উত্তেজনা চলে যাক।',
      ],
    },
    {
      'title': 'মুখমণ্ডল', // Face
      'icon': Icons.face, // Icon representing facial features
      'prompts': [
        'আপনার ভ্রু দুটিকে যতটা সম্ভব উঁচুতে তুলুন (কপাল)। ৭ সেকেন্ড ধরে রাখুন।',
        'ছেড়ে দিন, কপাল মসৃণ হতে দিন।',
        'এবার চোখ দুটি শক্ত করে বন্ধ করুন। ৭ সেকেন্ড ধরে রাখুন।',
        'ছেড়ে দিন, চোখের পাতা নরমভাবে বিশ্রাম নিক।',
        'আপনার চোয়াল শক্ত করুন। ৭ সেকেন্ড ধরে রাখুন।',
        'ছেড়ে দিন, চোয়াল শিথিল হতে দিন।',
      ],
    },
    {
      'title': 'বুক ও পেট', // Chest & Stomach
      'icon': Icons.fitness_center, // Represents core engagement
      'prompts': [
        'একটি গভীর শ্বাস নিন এবং ধরে রাখুন, আপনার বুক ও পেটে টান অনুভব করুন।',
        '৭ সেকেন্ড ধরে রাখুন।',
        'ধীরে ধীরে শ্বাস ছাড়ুন, সমস্ত বাতাস বের করে দিন এবং আপনার বুক ও পেট সম্পূর্ণ শিথিল হতে দিন।',
      ],
    },
    {
      'title': 'পা ও পায়ের পাতা', // Legs & Feet
      'icon': Icons.directions_walk, // Represents lower body movement
      'prompts': [
        'আপনার ডান পায়ের পেশী শক্ত করুন (হাঁটুর উপর চাপ দিয়ে)। ৭ সেকেন্ড ধরে রাখুন।',
        'ছেড়ে দিন, আপনার পা ভারী ও শিথিল হতে দিন। (বাম পায়ের জন্য পুনরাবৃত্তি করুন)',
        'আপনার ডান পায়ের আঙ্গুলগুলো নিচের দিকে বাঁকান (পায়ের পাতার দিকে)। ৭ সেকেন্ড ধরে রাখুন।',
        'ছেড়ে দিন, আপনার পা সম্পূর্ণ শিথিল হতে দিন। (বাম পায়ের জন্য পুনরাবৃত্তি করুন)',
      ],
    },
    {
      'title': 'সমাপ্তি ও প্রতিফলন', // Conclusion & Reflection
      'icon': Icons.check_circle_outline,
      'prompts': [
        'এখন আপনার পুরো শরীর লক্ষ্য করুন। মাথা থেকে পা পর্যন্ত স্ক্যান করুন।',
        'যেখানে অবশিষ্ট উত্তেজনা আছে তা সচেতনভাবে ছেড়ে দিন।',
        'এই গভীর শিথিলতার অনুভূতি উপভোগ করুন।',
        'যখন প্রস্তুত, ধীরে ধীরে চোখ খুলুন এবং আপনার মনোযোগ কক্ষে ফিরিয়ে আনুন।',
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
    if (_currentStepIndex >= 0 && _currentStepIndex < _pmrStepsDetails.length) {
      final currentPrompts =
          _pmrStepsDetails[_currentStepIndex]['prompts'] as List<String>;
      if (currentPrompts.length > 1) {
        _promptTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
          // Increased duration for PMR prompts
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
      if (_currentStepIndex < _pmrStepsDetails.length - 1) {
        _currentStepIndex++;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      } else {
        _currentStepIndex = _pmrStepsDetails.length; // Indicate completion
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
          "প্রগ্রেসিভ মাসল রিল্যাক্সেশন", // Progressive Muscle Relaxation
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor:
            Colors.lightGreen.shade700, // PMR specific AppBar color
        elevation: 4, // Consistent shadow for depth
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Progress Indicator ---
          if (_currentStepIndex > -1 &&
              _currentStepIndex < _pmrStepsDetails.length)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pmrStepsDetails.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentStepIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentStepIndex == index
                          ? Colors.lightGreen.shade700
                          : Colors.lightGreen
                              .shade200, // PMR specific progress color
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          // --- Main Content Area ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: _currentStepIndex == -1 // Intro/Ready State
                  ? _buildIntroAndDisclaimer()
                  : _currentStepIndex ==
                          _pmrStepsDetails.length // Completed State
                      ? _buildCompletionState()
                      : _buildActiveExerciseStep(), // Active Step State
            ),
          ),
          // --- Action Buttons ---
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
              width: double.infinity,
              child: _buildActionButton(),
            ),
          ),
        ],
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
          "প্রগ্রেসিভ মাসল রিল্যাক্সেশন", // Progressive Muscle Relaxation
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen.shade800), // PMR specific text color
        ),
        const SizedBox(height: 20),
        Text(
          _pmrIntroBn,
          style:
              const TextStyle(fontSize: 17, height: 1.6, color: Colors.black87),
        ),
        const Spacer(),
        Container(
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
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget to build the active exercise step
  Widget _buildActiveExerciseStep() {
    final currentStep = _pmrStepsDetails[_currentStepIndex];
    final List<String> prompts = currentStep['prompts'];
    final String currentPrompt = prompts[_currentPromptSubIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(currentStep['icon'] as IconData,
            size: 80,
            color: Colors.lightGreen.shade700), // PMR specific icon color
        const SizedBox(height: 20),
        Text(
          currentStep['title']!, // Display the muscle group title
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28, // Larger font for the step title
            fontWeight: FontWeight.bold,
            color: Colors.lightGreen.shade800, // PMR specific text color
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
            size: 80, color: Colors.lightGreen.shade600), // PMR specific green
        const SizedBox(height: 16),
        Text(
          "অভিনন্দন! আপনি প্রগ্রেসিভ মাসল রিল্যাক্সেশন সফলভাবে সম্পন্ন করেছেন। আশা করি আপনি এখন আরও শান্ত এবং শিথিল অনুভব করছেন।",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.lightGreen.shade700, // PMR specific text color
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "যখনই আপনার মানসিক চাপ বা উত্তেজনা অনুভব হয়, এই অনুশীলনটি আবার ব্যবহার করতে পারেন।",
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
          Colors.lightGreen.shade700; // PMR specific primary action color
      onPressedAction = _startExercise;
    } else if (_currentStepIndex == _pmrStepsDetails.length) {
      buttonText = "আবার শুরু করুন"; // Start Again
      buttonIcon = Icons.refresh;
      buttonColor =
          Colors.lightGreen.shade500; // Slightly lighter for secondary action
      onPressedAction = _resetExercise;
    } else {
      buttonText = _currentStepIndex == _pmrStepsDetails.length - 1
          ? 'অনুশীলন শেষ করুন' // Finish Exercise
          : 'পরবর্তী ধাপ'; // Next Step
      buttonIcon = _currentStepIndex == _pmrStepsDetails.length - 1
          ? Icons.check_circle_outline
          : Icons.arrow_forward;
      buttonColor = Colors.lightGreen.shade700;
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
                BorderRadius.circular(12)), // Consistent rounded corners
        elevation: 4, // Subtle shadow for depth
      ),
    );
  }
}
