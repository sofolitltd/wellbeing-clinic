import 'dart:async';

import 'package:flutter/material.dart';

// Define the different phases of a mindfulness session
enum MindfulnessPhase {
  introduction, // ভূমিকার ধাপ (Introduction Phase)
  prepare, // প্রস্তুতি: মনকে স্থির করা (Preparation: Settling the Mind)
  focusBreath, // শ্বাসের উপর মনোযোগ (Focus on Breath)
  observeThoughtsEmotions, // চিন্তা ও আবেগ পর্যবেক্ষণ (Observing Thoughts & Emotions)
  bodyScan, // শরীরের উপর মনোযোগ (Body Scan)
  soundsAwareness, // শব্দ সচেতনতা (New: Awareness of Sounds)
  returnFocusGentle, // মনোযোগ ফিরিয়ে আনা (Gently Returning Focus)
  endingReflection, // সমাপ্তি ও প্রতিফলন (Ending & Reflection)
}

final List<Map<String, String>> _mindfulnessStepsBn = const [
  {
    'title': '১. শান্ত পরিবেশ নির্বাচন',
    'description':
        'মাইন্ডফুলনেসর জন্য একটি শান্ত এবং নিরাপদ স্থান বেছে নিন যেখানে আপনি বাধাহীন থাকতে পারবেন। আরামদায়ক কিন্তু সতর্ক ভঙ্গিতে বসুন।',
  },
  {
    'title': '২. মৃদুভাবে চোখ বন্ধ করুন',
    'description':
        'চোখ হালকা করে বন্ধ করুন অথবা দৃষ্টিকে নিচের দিকে যেকোনো একটি স্থির বিন্দুতে স্থির করুন।',
  },
  {
    'title': '৩. শ্বাস-প্রশ্বাসে মনোযোগ স্থাপন',
    'description':
        'আপনার শ্বাসের প্রাকৃতিক প্রবাহকে লক্ষ্য করুন। অনুভব করুন বাতাস কিভাবে ভেতরে প্রবেশ করছে এবং বের হয়ে যাচ্ছে। এটি কোনোভাবে নিয়ন্ত্রণ করার চেষ্টা করবেন না, শুধু লক্ষ্য করুন।',
  },
  {
    'title': '৪. চিন্তা ও আবেগের প্রতি সচেতনতা',
    'description':
        'আপনার মনে যে চিন্তা বা অনুভূতিগুলো আসছে, সেগুলোকে লক্ষ্য করুন। কোনো বিচার না করে, শুধু তাদের উপস্থিতি সম্পর্কে সচেতন থাকুন। মেঘ যেমন আকাশ দিয়ে ভেসে যায়, তেমনই তাদের ভেসে যেতে দিন।',
  },
  {
    'title': '৫. মনোযোগ ফিরিয়ে আনা',
    'description':
        'যখন আপনার মন বিক্ষিপ্ত হবে বা অন্য কিছুতে চলে যাবে, তখন আলতো করে, কোনো রাগ বা হতাশাবোধ ছাড়াই, আপনার মনোযোগ আবার শ্বাসের দিকে ফিরিয়ে আনুন।',
  },
  {
    'title': '৬. বর্তমান মুহূর্তে অবস্থান',
    'description':
        'অনুশীলনের বাকি সময়টায় শুধু বর্তমান মুহূর্তে, আপনার শ্বাস ও আপনার শরীরের উপলব্ধির প্রতি মনোযোগ ধরে রাখুন।',
  },
  {
    'title': '৭. ধীরে ধীরে সেশন শেষ করা',
    'description':
        'যখন সেশন শেষ হবে, তখন ধীরে ধীরে আপনার চোখ খুলুন এবং আপনার চারপাশের পরিবেশের প্রতি আবার সচেতন হোন। এই প্রশান্তির অনুভূতি আপনার দৈনন্দিন জীবনে নিয়ে যান।',
  },
];

class MindfulnessPage extends StatefulWidget {
  const MindfulnessPage({super.key});

  @override
  State<MindfulnessPage> createState() => _MindfulnessPageState();
}

class _MindfulnessPageState extends State<MindfulnessPage> {
  // --- Session Configuration ---
  int _sessionDurationInMinutes =
      10; // Default session duration for professional use
  late int _totalDurationInSeconds; // Calculated total duration
  int _elapsedSeconds = 0; // Seconds elapsed in current session

  // --- Session State Variables ---
  MindfulnessPhase _currentPhase =
      MindfulnessPhase.introduction; // Start with introduction
  Timer? _sessionTimer; // Main session timer
  Timer? _promptTimer; // Timer for cycling sub-prompts within a phase
  bool _isSessionActive = false; // Tracks if the main session timer is running
  int _currentPromptSubIndex = 0; // Index for current sub-prompt

  // Professional Introduction and Disclaimer
  final String _professionalIntroBn =
      "মাইন্ডফুলনেস অনুশীলন হলো বর্তমান মুহূর্তে সম্পূর্ণরূপে উপস্থিত থাকার একটি প্রমাণিত কৌশল। এটি মানসিক চাপ (Stress) কমাতে, আবেগ নিয়ন্ত্রণ (Emotional Regulation) উন্নত করতে, আত্ম-সচেতনতা (Self-awareness) বাড়াতে এবং সামগ্রিক মানসিক সুস্বাস্থ্য (Mental Well-being) উন্নীত করতে সাহায্য করে। এই অনুশীলন আপনাকে আপনার চিন্তা ও অনুভূতির সাথে সম্পর্ক তৈরি করতে সহায়তা করবে, তবে সেগুলোতে হারিয়ে না গিয়ে।";

  final String _professionalDisclaimerBn =
      "**গুরুত্বপূর্ণ দ্রষ্টব্য:** এই মাইন্ডফুলনেস অনুশীলনটি একজন মনোবিজ্ঞানী বা থেরাপিস্টের নির্দেশনায় একটি সাপোর্টিভ টুল হিসেবে ডিজাইন করা হয়েছে। এটি কোনো মানসিক রোগ নির্ণয়, চিকিৎসা বা নিরাময়ের উদ্দেশ্যে নয় এবং পেশাদার মনস্তাত্ত্বিক পরামর্শ বা থেরাপির বিকল্প হিসেবে বিবেচিত হবে না। যদি আপনার গুরুতর মানসিক স্বাস্থ্য সংক্রান্ত উদ্বেগ থাকে, তাহলে অনুগ্রহ করে একজন লাইসেন্সপ্রাপ্ত মানসিক স্বাস্থ্য পেশাদারের সাথে পরামর্শ করুন।";

  // Core Mindfulness Phases with detailed sub-prompts and examples
  final List<Map<String, dynamic>> _mindfulnessPhasesDetails = const [
    {
      'phase': MindfulnessPhase.prepare,
      'title': 'প্রস্তুতি: একটি শান্ত জায়গা খুঁজুন',
      'icon': Icons.self_improvement,
      'prompts': [
        'একটি শান্ত এবং আরামদায়ক অবস্থানে বসুন বা শুয়ে পড়ুন। আপনার মেরুদণ্ড সোজা রাখুন।',
        'আপনার হাতদুটি কোলে রাখুন এবং চোখ হালকা করে বন্ধ করুন, অথবা দৃষ্টিকে নিচের দিকে যেকোনো একটি স্থির বিন্দুতে স্থির করুন।',
        'আপনার শরীরকে শিথিল হতে দিন। কোনো টান বা অস্বস্তি থাকলে, সেগুলোকে লক্ষ্য করুন।',
      ],
    },
    {
      'phase': MindfulnessPhase.focusBreath,
      'title': 'শ্বাসের উপর মনোযোগ দিন',
      'icon': Icons.air,
      'prompts': [
        'আপনার শ্বাসের প্রাকৃতিক ছন্দের প্রতি মনোযোগ দিন। শ্বাস কিভাবে ভেতরে প্রবেশ করছে এবং বের হয়ে যাচ্ছে, তা লক্ষ্য করুন।',
        'অনুভব করুন আপনার নাক দিয়ে বাতাস প্রবেশ করছে, বুক ও পেট উঠছে-নামছে।',
        'শ্বাসকে নিয়ন্ত্রণ করার চেষ্টা করবেন না, শুধু এটিকে যেমন আছে তেমনই লক্ষ্য করুন – গভীর বা অগভীর, দ্রুত বা ধীর।',
      ],
    },
    {
      'phase': MindfulnessPhase.observeThoughtsEmotions,
      'title': 'চিন্তা ও আবেগ পর্যবেক্ষণ করুন',
      'icon': Icons.psychology,
      'prompts': [
        'আপনার মনে যে চিন্তা বা অনুভূতিগুলো আসছে, সেগুলোকে লক্ষ্য করুন। এগুলোকে বাধা দেবেন না বা জোর করে তাড়াবেন না।',
        'কোনো বিচার না করে, শুধু তাদের উপস্থিতি সম্পর্কে সচেতন থাকুন। যেমন - ‘এটি একটি উদ্বেগের চিন্তা’ বা ‘এটি বিরক্তির অনুভূতি’।',
        'মেঘ যেমন আকাশ দিয়ে ভেসে যায়, তেমনই আপনার চিন্তাগুলোকে ভেসে যেতে দিন। সেগুলোতে জড়িয়ে যাবেন না, শুধু তাদের লক্ষ্য করুন।',
      ],
    },
    {
      'phase': MindfulnessPhase.bodyScan,
      'title': 'শরীর স্ক্যান করুন',
      'icon': Icons.accessibility_new,
      'prompts': [
        'আপনার মনোযোগ আপনার শরীরের বিভিন্ন অংশে নিয়ে যান। কোনো বিশেষ স্থানে টান, উষ্ণতা, বা স্পন্দন অনুভব করছেন কি?',
        'পায়ের পাতা থেকে শুরু করে ধীরে ধীরে উপরের দিকে, মাথার তালু পর্যন্ত প্রতিটি অংশ অনুভব করুন।',
        'কোথাও যদি কোনো টান বা অস্বস্তি থাকে, তাহলে সেই স্থানে আপনার শ্বাসকে নিয়ে যান এবং তাকে আলতো করে শিথিল হতে দিন।',
      ],
    },
    {
      'phase': MindfulnessPhase.soundsAwareness,
      'title': 'শব্দ সচেতনতা',
      'icon': Icons.volume_up,
      'prompts': [
        'আপনার চারপাশের শব্দগুলোর প্রতি মনোযোগ দিন। কাছাকাছি বা দূরবর্তী শব্দ, যেকোনো ধরনের শব্দ হতে পারে।',
        'যেমন: ফ্যানের শব্দ, গাড়ির আওয়াজ, পাখির কিচিরমিচির, বা আপনার নিজের শ্বাস-প্রশ্বাস।',
        'শব্দগুলোকে বিশ্লেষণ না করে, শুধু তাদের উপস্থিতির প্রতি সচেতন থাকুন।',
      ],
    },
    {
      'phase': MindfulnessPhase.returnFocusGentle,
      'title': 'মনোযোগ ফিরিয়ে আনা',
      'icon': Icons.redo,
      'prompts': [
        'যদি আপনার মন অনুশীলন থেকে বিচ্যুত হয় বা অন্য কিছুতে চলে যায়, তবে এটা স্বাভাবিক। মন wandering করবেই।',
        'কোনো রাগ বা হতাশাবোধ ছাড়াই, আলতো করে আপনার মনোযোগ আবার শ্বাসের দিকে, অথবা আপনার দেহের উপলব্ধির দিকে ফিরিয়ে আনুন।',
        'এটি মাইন্ডফুলনেসর একটি মূল অংশ: যতবার মন দূরে যায়, ততবারই ধৈর্যের সাথে ফিরিয়ে আনুন।',
      ],
    },
    {
      'phase': MindfulnessPhase.endingReflection,
      'title': 'অনুশীলন সম্পন্ন হয়েছে',
      'icon': Icons.check_circle_outline,
      'prompts': [
        'অনুশীলনটি সফলভাবে সম্পন্ন হয়েছে। এই মুহূর্তের শান্তি এবং প্রশান্তি অনুভব করুন।',
        'ধীরে ধীরে আপনার চোখ খুলুন এবং আপনার চারপাশের পরিবেশের প্রতি আবার সচেতন হোন, এই শান্ত অনুভূতিকে সঙ্গে নিয়ে।',
        'আপনার মাইন্ডফুলনেসর যাত্রা অব্যাহত রাখুন। এই অনুশীলনটি আপনাকে প্রতিদিনের জীবনে আরও ভারসাম্য এবং সচেতনতা আনতে সহায়তা করবে।',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _totalDurationInSeconds = _sessionDurationInMinutes * 60;
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _promptTimer?.cancel();
    super.dispose();
  }

  // --- Session Control Methods ---

  void _startSession(int durationInMinutes) {
    setState(() {
      _isSessionActive = true;
      _elapsedSeconds = 0;
      _currentPhase =
          MindfulnessPhase.prepare; // Start with the first active guided phase
      _sessionDurationInMinutes = durationInMinutes; // Set chosen duration
      _totalDurationInSeconds = _sessionDurationInMinutes * 60; // Recalculate
      _currentPromptSubIndex = 0; // Reset sub-prompt index
    });
    _startGuidedTimer(); // Start main session timer
    _startPromptTimer(); // Start sub-prompt cycling timer
  }

  void _stopSession() {
    _sessionTimer?.cancel();
    _promptTimer?.cancel();
    setState(() {
      _isSessionActive = false;
      _elapsedSeconds = 0;
      _currentPhase =
          MindfulnessPhase.introduction; // Reset to introduction phase
      _currentPromptSubIndex = 0; // Reset sub-prompt index
    });
  }

  // Starts the main session timer
  void _startGuidedTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_elapsedSeconds < _totalDurationInSeconds) {
          _elapsedSeconds++;
          _updatePhase(); // Update main phase based on elapsed time
        } else {
          // Session is truly over, transition to ending reflection
          _currentPhase = MindfulnessPhase.endingReflection;
          _sessionTimer?.cancel(); // Stop main timer
          _promptTimer?.cancel(); // Stop sub-prompt timer
          _isSessionActive = false;
          _currentPromptSubIndex = 0; // Show first ending prompt
          _startPromptTimer(); // Start timer for ending prompts

          // After showing ending for a few seconds, reset completely
          Future.delayed(const Duration(seconds: 15), () {
            // Give time for ending reflection
            if (mounted) {
              // Ensure widget is still in tree before setState
              _resetExercise();
            }
          });
        }
      });
    });
  }

  // Starts timer for cycling through sub-prompts within the current main phase
  void _startPromptTimer() {
    _promptTimer?.cancel();
    final currentPhaseDetail = _mindfulnessPhasesDetails.firstWhere(
      (element) => element['phase'] == _currentPhase,
      orElse: () => {
        'prompts': ['']
      }, // Fallback for safety
    );
    final List<String> prompts = currentPhaseDetail['prompts'] as List<String>;

    if (prompts.length > 1) {
      _promptTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
        // Cycle every 8 seconds
        setState(() {
          _currentPromptSubIndex =
              (_currentPromptSubIndex + 1) % prompts.length;
        });
      });
    } else {
      _currentPromptSubIndex = 0; // Ensure it's 0 if only one prompt
    }
  }

  // Determines the current main mindfulness phase based on elapsed time
  void _updatePhase() {
    // Dynamically assign duration for each core phase based on total session time
    final int totalActiveDuration = _totalDurationInSeconds;

    int currentAccumulatedDuration = 0;
    final Map<MindfulnessPhase, int> phaseDurations = {};

    // Assign durations proportionally (rough estimates for a good flow)
    // Total percentages should sum to 100% for the active session.
    phaseDurations[MindfulnessPhase.prepare] =
        (totalActiveDuration * 0.10).toInt(); // 10%
    phaseDurations[MindfulnessPhase.focusBreath] =
        (totalActiveDuration * 0.20).toInt(); // 20%
    phaseDurations[MindfulnessPhase.observeThoughtsEmotions] =
        (totalActiveDuration * 0.25).toInt(); // 25%
    phaseDurations[MindfulnessPhase.bodyScan] =
        (totalActiveDuration * 0.20).toInt(); // 20%
    phaseDurations[MindfulnessPhase.soundsAwareness] =
        (totalActiveDuration * 0.10).toInt(); // 10%
    phaseDurations[MindfulnessPhase.returnFocusGentle] =
        (totalActiveDuration * 0.15).toInt(); // 15%

    if (_elapsedSeconds <
        (currentAccumulatedDuration +=
            phaseDurations[MindfulnessPhase.prepare]!)) {
      if (_currentPhase != MindfulnessPhase.prepare) {
        _currentPhase = MindfulnessPhase.prepare;
        _currentPromptSubIndex = 0; // Reset sub-prompt index for new phase
        _startPromptTimer();
      }
    } else if (_elapsedSeconds <
        (currentAccumulatedDuration +=
            phaseDurations[MindfulnessPhase.focusBreath]!)) {
      if (_currentPhase != MindfulnessPhase.focusBreath) {
        _currentPhase = MindfulnessPhase.focusBreath;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      }
    } else if (_elapsedSeconds <
        (currentAccumulatedDuration +=
            phaseDurations[MindfulnessPhase.observeThoughtsEmotions]!)) {
      if (_currentPhase != MindfulnessPhase.observeThoughtsEmotions) {
        _currentPhase = MindfulnessPhase.observeThoughtsEmotions;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      }
    } else if (_elapsedSeconds <
        (currentAccumulatedDuration +=
            phaseDurations[MindfulnessPhase.bodyScan]!)) {
      if (_currentPhase != MindfulnessPhase.bodyScan) {
        _currentPhase = MindfulnessPhase.bodyScan;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      }
    } else if (_elapsedSeconds <
        (currentAccumulatedDuration +=
            phaseDurations[MindfulnessPhase.soundsAwareness]!)) {
      if (_currentPhase != MindfulnessPhase.soundsAwareness) {
        _currentPhase = MindfulnessPhase.soundsAwareness;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      }
    } else if (_elapsedSeconds <
        (currentAccumulatedDuration +=
            phaseDurations[MindfulnessPhase.returnFocusGentle]!)) {
      if (_currentPhase != MindfulnessPhase.returnFocusGentle) {
        _currentPhase = MindfulnessPhase.returnFocusGentle;
        _currentPromptSubIndex = 0;
        _startPromptTimer();
      }
    }
  }

  // Helper to get the current main guidance prompt (Bengali)
  String _getCurrentGuidancePrompt() {
    final currentPhaseDetail = _mindfulnessPhasesDetails.firstWhere(
      (element) => element['phase'] == _currentPhase,
      orElse: () => {
        'prompts': ['অনুশীলনের জন্য প্রস্তুত হন...']
      }, // Fallback for safety
    );
    final List<String> prompts = currentPhaseDetail['prompts'] as List<String>;
    if (_currentPromptSubIndex >= 0 &&
        _currentPromptSubIndex < prompts.length) {
      return prompts[_currentPromptSubIndex];
    }
    return prompts.isNotEmpty
        ? prompts[0]
        : 'অনুশীলনের জন্য প্রস্তুত হন...'; // Fallback if prompts list is empty or index is bad
  }

  // Helper to get time remaining text (Bengali)
  String _getTimeRemainingText() {
    final int remainingSeconds = _totalDurationInSeconds - _elapsedSeconds;
    final int minutes = remainingSeconds ~/ 60;
    final int seconds = remainingSeconds % 60;

    if (_isSessionActive ||
        _currentPhase == MindfulnessPhase.endingReflection) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} বাকি'; // remaining
    }
    return ''; // No time remaining displayed when in intro state
  }

  void _resetExercise() {
    _stopSession(); // This already resets to introduction phase
  }

  // --- New: Show Duration Selection Dialog ---
  Future<void> _showDurationSelectionDialog() async {
    int? selectedDuration = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) {
        int tempSelectedDuration =
            _sessionDurationInMinutes; // Use current value as initial

        return StatefulBuilder(
          // Use StatefulBuilder to update dialog content
          builder: (context, setStateInDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(
                'সেশনের সময়কাল নির্বাচন করুন', // Select Session Duration
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue.shade800),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'আপনি কতক্ষণ মাইন্ডফুলনেস অনুশীলন করতে চান?', // How long do you want to practice mindfulness?
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: tempSelectedDuration.toDouble(),
                    min: 1.0,
                    max: 30.0,
                    divisions: 29, // 1 to 30 minutes
                    label: '${tempSelectedDuration} মিনিট',
                    onChanged: (double newValue) {
                      setStateInDialog(() {
                        // Update state of the dialog
                        tempSelectedDuration = newValue.round();
                      });
                    },
                    activeColor: Colors.lightBlue.shade600,
                    inactiveColor: Colors.lightBlue.shade200,
                  ),
                  Text(
                    '${tempSelectedDuration} মিনিট', // X minutes
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss dialog
                  },
                  child: Text(
                    'বাতিল করুন', // Cancel
                    style: TextStyle(color: Colors.red.shade600, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext)
                        .pop(tempSelectedDuration); // Return selected duration
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'শুরু করুন', // Start
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedDuration != null) {
      _startSession(selectedDuration); // Start session with chosen duration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Consistent white background
      appBar: AppBar(
        title: const Text(
          "মাইন্ডফুলনেস অনুশীলন", // Mindfulness Exercise
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
              // --- Main Content Area (No Card) ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0), // Consistent padding
                  child: _currentPhase == MindfulnessPhase.introduction
                      ? _buildIntroAndDisclaimer() // Initial state with disclaimer and duration selector
                      : _currentPhase == MindfulnessPhase.endingReflection
                          ? _buildCompletionState() // Session completed state
                          : _buildActiveSessionState(), // Active guided session state
                ),
              ),
              // --- Action Buttons (Below the main content) ---
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

  // --- Widget Builders for Different States ---

  // Builds the professional introduction and disclaimer section
  Widget _buildIntroAndDisclaimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20), // Initial spacing
        Text(
          "মাইন্ডফুলনেস অনুশীলনের উদ্দেশ্য ও উপকারিতা", // Purpose and Benefits of Mindfulness Practice
          style: TextStyle(
              fontSize: 28, // Larger font for main title
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue.shade800), // Consistent primary color
        ),
        const SizedBox(height: 20),
        Text(
          _professionalIntroBn,
          style: const TextStyle(
              fontSize: 17, // Larger body font
              height: 1.6,
              color: Colors.black87),
        ),
        const SizedBox(height: 30),

        // Disclaimer container styling consistent with CBT page
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Text(
            _professionalDisclaimerBn,
            style: TextStyle(
              fontSize: 13,
              color: Colors.red.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        const SizedBox(height: 20), // Spacing for button
        // Detailed instructions section moved here from the main build method
        _buildInstructionsSection(),
      ],
    );
  }

  // Widget to build the active exercise state (guided session)
  Widget _buildActiveSessionState() {
    final currentPhaseDetail = _mindfulnessPhasesDetails.firstWhere(
      (element) => element['phase'] == _currentPhase,
      orElse: () => _mindfulnessPhasesDetails.first, // Fallback to prepare
    );

    final double progress = _totalDurationInSeconds > 0
        ? _elapsedSeconds / _totalDurationInSeconds
        : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(currentPhaseDetail['icon'] as IconData,
            size: 80, // Slightly larger icon
            color: Colors.lightBlue.shade700), // Consistent icon color
        const SizedBox(height: 20),
        Text(
          currentPhaseDetail['title']!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28, // Larger for main title
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue.shade800, // Consistent primary color
          ),
        ),
        const SizedBox(height: 30),
        // Display current sub-prompt with animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            _getCurrentGuidancePrompt(),
            key: ValueKey<int>(_currentPromptSubIndex), // Key for animation
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18, // Consistent body font size
              fontStyle: FontStyle.italic,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          color: Colors.lightBlue.shade400, // Consistent progress color
          minHeight: 12,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 10),
        Text(
          _getTimeRemainingText(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
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
          _getCurrentGuidancePrompt(), // This will show the final reflection prompt
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "আপনার মাইন্ডফুলনেসর যাত্রা অব্যাহত রাখুন। এই অনুশীলনটি আপনাকে প্রতিদিনের জীবনে আরও প্রশান্তি এবং ভারসাম্য আনতে সহায়তা করবে। আপনি যখনই প্রয়োজন মনে করেন, আবার অনুশীলন করতে পারেন।",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // Unified Action Button (Start, Stop, Restart)
  Widget _buildActionButton() {
    String buttonText;
    IconData buttonIcon;
    Color buttonColor;
    VoidCallback onPressedAction;

    if (!_isSessionActive && _currentPhase == MindfulnessPhase.introduction) {
      buttonText = "সেশন শুরু করুন"; // Start Session
      buttonIcon = Icons.play_arrow;
      buttonColor =
          Colors.lightBlue.shade700; // Consistent primary action color
      onPressedAction =
          _showDurationSelectionDialog; // Call dialog before starting
    } else if (_isSessionActive) {
      buttonText = "সেশন বন্ধ করুন"; // Stop Session
      buttonIcon = Icons.stop;
      buttonColor = Colors.red.shade600; // Consistent stop color
      onPressedAction = _stopSession;
    } else {
      buttonText = "আবার শুরু করুন"; // Start Again
      buttonIcon = Icons.refresh;
      buttonColor =
          Colors.lightBlue.shade500; // Consistent secondary action color
      onPressedAction = _resetExercise;
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
        elevation: 4, // Consistent shadow for depth
      ),
    );
  }

  // Builds the detailed instructions section (now matching the overall design)
  Widget _buildInstructionsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20), // Spacing from above content
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50, // Lighter background for this section
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.lightBlue.shade100), // Subtle border
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // No divider line in ExpansionTile
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary:
                    Colors.lightBlue.shade700, // Color for ExpansionTile icon
              ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionTile(
            initiallyExpanded: false,
            title: const Text(
              'অনুশীলনের মূল ধাপসমূহ (বিস্তারিত)', // Key Steps of Practice (Detailed)
              style: TextStyle(
                fontSize: 18, // Consistent font size for section titles
                fontWeight: FontWeight.w600,
                color: Colors.lightBlue, // Consistent color
              ),
            ),
            childrenPadding: const EdgeInsets.all(20.0),
            children: [
              ..._mindfulnessStepsBn
                  .map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              step['description']!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
